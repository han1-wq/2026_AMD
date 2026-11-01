#include "services.h"
#include "link.h"
#include "dma_transport.h"
#include "net_trace.h"
#ifdef OFDM_SERVICES_TEST
#include "services_test_platform.h"
#else
#include "lwip/init.h"
#include "lwip/tcp.h"
#include "lwip/timeouts.h"
#include "lwip/etharp.h"
#include "lwip/ip4_frag.h"
#include "netif/xemacpsif.h"
#include "netif/xadapter.h"
#include "xuartps_hw.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xtime_l.h"
#endif
#include <string.h>

#ifndef BOARD_ID
#define BOARD_ID 10
#endif
#ifndef BOARD_SUBNET
#define BOARD_SUBNET 1
#endif
#define IMAGE_MAX (16U*1024*1024)
#define TCP_RING 65536U
#define UART_RING 16384U
#define UART_BASE XPAR_PS7_UART_1_BASEADDR
static struct netif interface;
static struct tcp_pcb *client;
static uint8_t input[TCP_RING], output[TCP_RING];
static uint32_t in_wr,in_rd,out_wr,out_rd;
static uint8_t uart_out[UART_RING], uart_in[1028];
static uint32_t uart_wr,uart_rd;
static unsigned uart_pos;
static uint32_t uart_last;
static uint8_t image[IMAGE_MAX], bitmap[(IMAGE_MAX/1000+8)/8];
static uint32_t image_session,image_id,image_total,image_crc,image_count,image_got;
static uint8_t image_channel;
static int image_active,image_complete;
// TCP uploads are metadata followed by sequential fragments; RF delivery may reorder.
static int upload_active;
static uint8_t upload_channel;
static uint32_t upload_session,upload_id,upload_total;
static int upload_failed;
static unsigned upload_count,upload_next;
static uint32_t upload_counters[DMA_COUNTER_COUNT+2];
static uint32_t now_ms, next_tcp_timer, next_link_timer;
static uint32_t next_arp_timer, next_reass_timer, next_rx_timer;
extern void tcp_tmr(void);

static uint32_t crc32(const uint8_t *p,unsigned n)
{
    uint32_t c=~0U; unsigned i;
    while(n--) { c^=*p++; for(i=0;i<8;++i) c=(c>>1)^((0U-(c&1))&0xedb88320U); }
    return ~c;
}
static unsigned enqueue_output(const uint8_t *p,unsigned n)
{
    unsigned i;
    if(n+2>TCP_RING-(out_wr-out_rd) || !client) return 0;
    output[out_wr++%TCP_RING]=n; output[out_wr++%TCP_RING]=n>>8;
    for(i=0;i<n;++i) output[out_wr++%TCP_RING]=p[i];
    return 1;
}
static unsigned status_record(unsigned code,uint32_t session,uint32_t id,uint32_t detail)
{
    uint8_t p[16]={'O','S',1,0};
    p[3]=code; link_put32(p+4,session); link_put32(p+8,id); link_put32(p+12,detail);
    return enqueue_output(p,sizeof(p));
}
static void counters(uint32_t values[DMA_COUNTER_COUNT+2])
{
    dma_transport_counters(values);
    values[DMA_COUNTER_COUNT]=link_retries;
    values[DMA_COUNTER_COUNT+1]=link_failures;
}
static unsigned upload_status(void)
{
    uint32_t values[DMA_COUNTER_COUNT+2]; unsigned i;
    // Fixed-size OS v1 records: old clients ignore these informational codes.
    // Reserve the entire diagnostic bundle plus final status, without duplicates.
    if(!client || TCP_RING-(out_wr-out_rd)<18*(DMA_COUNTER_COUNT+3)) return 0;
    counters(values);
    for(i=0;i<DMA_COUNTER_COUNT+2;++i)
        status_record(16+i,upload_session,upload_id,values[i]-upload_counters[i]);
    return status_record(upload_failed?5:6,upload_session,upload_id,upload_total);
}
static void disconnected(void *arg,err_t err)
{
    (void)arg; (void)err; client=0; in_rd=in_wr=out_rd=out_wr=0;
    if(upload_active) link_cancel_image(upload_channel,upload_session,upload_id);
    upload_active=0;
    image_active=0;
}
static void packet_failed(const uint8_t *p,unsigned n)
{
    (void)n;
    if(upload_active && (p[3]==LINK_IMAGE_META || p[3]==LINK_IMAGE_DATA) &&
        p[5]==upload_channel && link_get32(p+6)==upload_session && link_get32(p+10)==upload_id)
    {
        upload_failed=1;
        link_cancel_image(upload_channel,upload_session,upload_id);
    }
}
static err_t tcp_receive(void *arg,struct tcp_pcb *pcb,struct pbuf *p,err_t err)
{
    unsigned i;
    (void)arg;
    if(!p) {
        tcp_recv(pcb,0); tcp_err(pcb,0);
        if(tcp_close(pcb)!=ERR_OK) { tcp_abort(pcb); disconnected(0,0); return ERR_ABRT; }
        disconnected(0,0); return ERR_OK;
    }
    if(err!=ERR_OK) { pbuf_free(p); return err; }
    if(p->tot_len>TCP_RING-(in_wr-in_rd)) return ERR_MEM;
    for(i=0;i<p->tot_len;++i) input[in_wr++%TCP_RING]=pbuf_get_at(p,i);
    // Advertise receive credit only after records enter the bounded link queue.
    pbuf_free(p); return ERR_OK;
}
static err_t tcp_accept_client(void *arg,struct tcp_pcb *pcb,err_t err)
{
    (void)arg;
    if(err!=ERR_OK) return err;
    if(client) { tcp_abort(pcb); return ERR_ABRT; }
    client=pcb; in_rd=in_wr=out_rd=out_wr=0;
    tcp_recv(pcb,tcp_receive); tcp_err(pcb,disconnected); tcp_nagle_disable(pcb);
    return ERR_OK;
}
static void tcp_service(void)
{
    unsigned budget=8;
    while(client && in_wr-in_rd>=2 && budget--) {
        uint8_t p[1024]; unsigned i,n=input[in_rd%TCP_RING] | (input[(in_rd+1)%TCP_RING]<<8);
        int result;
        if(n<24 || n>1024) { tcp_abort(client); disconnected(0,0); break; }
        if(in_wr-in_rd<n+2) break;
        for(i=0;i<n;++i) p[i]=input[(in_rd+2+i)%TCP_RING];
        if(!link_validate(p,n) || (p[3]!=LINK_IMAGE_META && p[3]!=LINK_IMAGE_DATA)) {
            status_record(3,0,0,0); in_rd+=n+2; tcp_recved(client,n+2); continue;
        }
        if(p[3]==LINK_IMAGE_META && upload_active) break;
        if(p[3]==LINK_IMAGE_DATA && (!upload_active || p[5]!=upload_channel ||
            link_get32(p+6)!=upload_session || link_get32(p+10)!=upload_id ||
            link_get32(p+20)!=upload_total || link_get16(p+16)!=upload_count ||
            link_get16(p+14)!=upload_next)) {
            status_record(3,link_get32(p+6),link_get32(p+10),0);
            in_rd+=n+2; tcp_recved(client,n+2); continue;
        }
        // Drain the remainder of a failed upload so TCP backpressure cannot
        // prevent the host from reaching its completion-status read.
        result=upload_active && upload_failed ? 1 : link_enqueue(p,n);
        if(result==0) break;
        if(result<0) status_record(3,0,0,0);
        else if(p[3]==LINK_IMAGE_META) {
            upload_active=1; upload_channel=p[5]; upload_session=link_get32(p+6);
            upload_id=link_get32(p+10); upload_total=link_get32(p+20);
            upload_count=link_get16(p+16); upload_next=0; upload_failed=0;
            counters(upload_counters);
        } else ++upload_next;
        in_rd+=n+2; tcp_recved(client,n+2);
    }
    if(client && upload_active && upload_next==upload_count &&
        !link_pending(upload_channel,upload_session,upload_id)) {
        if(upload_status())
            upload_active=0;
    }
    if(client && out_wr!=out_rd) {
        unsigned n=out_wr-out_rd, contiguous=TCP_RING-out_rd%TCP_RING;
        if(n>contiguous) n=contiguous;
        if(n>tcp_sndbuf(client)) n=tcp_sndbuf(client);
        if(n && tcp_write(client,output+out_rd%TCP_RING,n,TCP_WRITE_FLAG_COPY)==ERR_OK) {
            out_rd+=n; tcp_output(client);
        }
    }
}
static void uart_service(void)
{
    unsigned budget=128;
    if(uart_pos && now_ms-uart_last>100) uart_pos=0;
    while(budget-- && XUartPs_IsReceiveData(UART_BASE)) {
        unsigned n;
        uint8_t b=XUartPs_ReadReg(UART_BASE,XUARTPS_FIFO_OFFSET);
        uart_last=now_ms;
        if(uart_pos==0 && b!=0xa5) continue;
        if(uart_pos==1 && b!=0x5a) { uart_pos=b==0xa5?1:0; continue; }
        uart_in[uart_pos++]=b;
        if(uart_pos<4) continue;
        n=link_get16(uart_in+2);
        if(n<24 || n>1024) { uart_pos=0; continue; }
        if(uart_pos==n+4) {
            uint8_t reply[5]={0x5a,0xa5,0x01,0,0};
            int result=uart_in[7]==LINK_UART ? link_enqueue(uart_in+4,n) : -1;
            reply[4]=result>0?0:result==0?1:2;
            if(UART_RING-(uart_wr-uart_rd)>=sizeof(reply)) {
                unsigned i; for(i=0;i<sizeof(reply);++i) uart_out[uart_wr++%UART_RING]=reply[i];
            }
            uart_pos=0;
        }
    }
    budget=128;
    while(budget-- && uart_rd!=uart_wr && !XUartPs_IsTransmitFull(UART_BASE))
        XUartPs_WriteReg(UART_BASE,XUARTPS_FIFO_OFFSET,uart_out[uart_rd++%UART_RING]);
}
int services_deliver(const uint8_t *p,unsigned n)
{
    uint32_t session=link_get32(p+6), id=link_get32(p+10), total=link_get32(p+20);
    unsigned index=link_get16(p+14), count=link_get16(p+16), length=n-24,i;
    if(p[3]==LINK_UART) {
        if(UART_RING-(uart_wr-uart_rd)<n+4) return 0;
        uart_out[uart_wr++%UART_RING]=0x5a; uart_out[uart_wr++%UART_RING]=0xa5;
        uart_out[uart_wr++%UART_RING]=n; uart_out[uart_wr++%UART_RING]=n>>8;
        for(i=0;i<n;++i) uart_out[uart_wr++%UART_RING]=p[i];
        return 1;
    }
    if(p[3]==LINK_IMAGE_META) {
        if(total>IMAGE_MAX || count!=(total+999)/1000) return 0;
        if(image_active && (session!=image_session || id!=image_id || p[5]!=image_channel) && !image_complete) return 0;
        if(!image_active || session!=image_session || id!=image_id || p[5]!=image_channel) {
            memset(bitmap,0,sizeof(bitmap)); image_got=0; image_complete=0;
            image_session=session; image_id=id; image_channel=p[5]; image_total=total;
            image_count=count; image_crc=link_get32(p+24); image_active=1;
        } else if(total!=image_total || count!=image_count || link_get32(p+24)!=image_crc) return 0;
        return enqueue_output(p,n);
    }
    if(p[3]!=LINK_IMAGE_DATA || !image_active || session!=image_session || id!=image_id ||
       p[5]!=image_channel || total!=image_total || count!=image_count) return 0;
    if(bitmap[index/8] & (1U<<(index%8))) return 1;
    if(image_got+1==image_count && TCP_RING-(out_wr-out_rd)<n+2+18) return 0;
    if(!enqueue_output(p,n)) return 0;
    memcpy(image+index*1000U,p+24,length);
    bitmap[index/8]|=1U<<(index%8); ++image_got;
    if(image_got==image_count) {
        uint32_t actual=crc32(image,image_total);
        image_complete=1;
        status_record(actual==image_crc?1:2,session,id,actual);
    }
    return 1;
}
int services_init(void)
{
    ip_addr_t ip,mask,gw;
    uint8_t mac[6]={2,0,0,0,0,BOARD_ID};
    struct tcp_pcb *pcb;
    Xil_ExceptionInit();
    if(XScuGic_DeviceInitialize(XPAR_SCUGIC_SINGLE_DEVICE_ID)!=XST_SUCCESS) return -1;
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
        (Xil_ExceptionHandler)XScuGic_DeviceInterruptHandler,(void *)XPAR_SCUGIC_SINGLE_DEVICE_ID);
    lwip_init();
    IP4_ADDR(&ip,192,168,BOARD_SUBNET,BOARD_ID); IP4_ADDR(&mask,255,255,255,0); IP4_ADDR(&gw,192,168,BOARD_SUBNET,1);
    if(!xemac_add(&interface,&ip,&mask,&gw,mac,XPAR_XEMACPS_0_BASEADDR)) return -1;
    net_trace_init(&interface);
    netif_set_default(&interface); netif_set_up(&interface); Xil_ExceptionEnable();
    pcb=tcp_new();
    if(!pcb || tcp_bind(pcb,IP_ADDR_ANY,5001)!=ERR_OK) return -1;
    pcb=tcp_listen(pcb); if(!pcb) return -1;
    tcp_accept(pcb,tcp_accept_client);
    return 0;
}
void services_poll(uint32_t now)
{
    now_ms=now;
    xemacif_input(&interface);
    if((int32_t)(now-next_tcp_timer)>=0) { tcp_tmr(); next_tcp_timer=now+250; }
    // NO_SYS_NO_TIMERS disables all lwIP cyclic timers, not only TCP.
    if((int32_t)(now-next_arp_timer)>=0) { etharp_tmr(); next_arp_timer=now+1000; }
#if IP_REASSEMBLY
    if((int32_t)(now-next_reass_timer)>=0) { ip_reass_tmr(); next_reass_timer=now+1000; }
#endif
    // Xilinx's Zynq GEM SI#692601 workaround checks RX progress every 100 ms.
    if((int32_t)(now-next_rx_timer)>=0) {
        xemacpsif_resetrx_on_no_rxdata(&interface); next_rx_timer=now+100;
    }
    if((int32_t)(now-next_link_timer)>=0) { eth_link_detect(&interface); next_link_timer=now+1000; }
    tcp_service(); uart_service();
}
void dma_application_run(void)
{
    XTime t;
    link_init(dma_transport_send,services_deliver);
    link_set_failure_handler(packet_failed);
    if(dma_transport_init(link_receive) || services_init()) {
        xil_printf("DMA/network initialization failed\r\n"); return;
    }
    xil_printf("DMA ready: 192.168.%d.%d:5001; UART business protocol v1\r\n",BOARD_SUBNET,BOARD_ID);
    for(;;) {
        uint32_t ms;
        XTime_GetTime(&t); ms=(uint32_t)(t/(COUNTS_PER_SECOND/1000));
        services_poll(ms);
        if(dma_transport_poll()) { status_record(4,0,0,0); break; }
        link_poll(ms);
    }
    // Keep status service alive; do not silently replay a failed DMA transaction.
    for(;;) { XTime_GetTime(&t); services_poll((uint32_t)(t/(COUNTS_PER_SECOND/1000))); }
}