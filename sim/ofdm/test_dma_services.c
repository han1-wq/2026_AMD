#include <assert.h>
#include <stdio.h>
#define OFDM_SERVICES_TEST
#include "../firmware/dma_app/services.c"
static struct tcp_pcb connection;
static unsigned credit;
static uint8_t radio_packet[1024], serial_input[1028], serial_output[2048];
static unsigned radio_length, serial_length, serial_position, serial_written;
static int radio_loopback;
static int radio_ready=1;
static uint32_t fake_counters[DMA_COUNTER_COUNT];
static unsigned tcp_ticks, arp_ticks, reass_ticks, rx_ticks, link_ticks;
void tcp_tmr(void) { ++tcp_ticks; }
void etharp_tmr(void) { ++arp_ticks; }
void ip_reass_tmr(void) { ++reass_ticks; }
void xemacpsif_resetrx_on_no_rxdata(struct netif *p) { (void)p; ++rx_ticks; }
void xemacif_input(struct netif *p) { (void)p; }
void eth_link_detect(struct netif *p) { (void)p; ++link_ticks; }
void dma_transport_counters(uint32_t values[DMA_COUNTER_COUNT])
{ memcpy(values,fake_counters,sizeof(fake_counters)); }
int XUartPs_IsReceiveData(unsigned base)
{ (void)base; return serial_position<serial_length; }
int XUartPs_IsTransmitFull(unsigned base) { (void)base; return 0; }
uint32_t XUartPs_ReadReg(unsigned base,unsigned reg)
{ (void)base; (void)reg; return serial_input[serial_position++]; }
void XUartPs_WriteReg(unsigned base,unsigned reg,unsigned value)
{ (void)base; (void)reg; assert(serial_written<sizeof(serial_output)); serial_output[serial_written++]=value; }
void tcp_abort(struct tcp_pcb *p) { (void)p; }
void tcp_recved(struct tcp_pcb *p,unsigned n) { (void)p; credit+=n; }
unsigned tcp_sndbuf(struct tcp_pcb *p) { (void)p; return 0; }
err_t tcp_write(struct tcp_pcb *p,const void *b,unsigned n,unsigned f)
{ (void)p; (void)b; (void)n; (void)f; return ERR_MEM; }
err_t tcp_output(struct tcp_pcb *p) { (void)p; return ERR_OK; }
static int transmit(const uint8_t *p,unsigned n,uint32_t cookie)
{
    (void)cookie;
    if(!radio_ready) return 0;
    if(radio_loopback) { assert(!radio_length); memcpy(radio_packet,p,n); radio_length=n; }
    return 1;
}
static void reset(void)
{
    disconnected(0,0); client=&connection; credit=0;
    radio_loopback=0; radio_length=0; radio_ready=1;
    uart_wr=uart_rd=uart_pos=serial_length=serial_position=serial_written=0;
    link_init(transmit,services_deliver); link_set_failure_handler(packet_failed);
}
static void make(uint8_t *p,unsigned type,unsigned id)
{
    memset(p,0,28); p[0]='O'; p[1]='F'; p[2]=1; p[3]=type;
    link_put32(p+6,123); link_put32(p+10,id); link_put16(p+16,1);
    link_put16(p+18,4); link_put32(p+20,4); memcpy(p+24,"test",4);
}
static void input_record(const uint8_t *p)
{
    unsigned i;
    input[in_wr++%TCP_RING]=28; input[in_wr++%TCP_RING]=0;
    for(i=0;i<28;++i) input[in_wr++%TCP_RING]=p[i];
}
static void acknowledge(uint8_t *p)
{
    uint8_t ack[25]; memcpy(ack,p,24); ack[24]=p[3]; ack[3]=LINK_ACK;
    link_put16(ack+18,1); link_receive(ack,25);
}
int main(void)
{
    uint8_t meta[28],data[28],uart[28]; unsigned i;
    // All manually scheduled timers must run, including across millisecond wrap.
    services_poll(0);
    services_poll(99);
    assert(tcp_ticks==1 && arp_ticks==1 && reass_ticks==1 && rx_ticks==1);
    services_poll(100); services_poll(249); services_poll(250);
    assert(tcp_ticks==2 && arp_ticks==1 && reass_ticks==1 && rx_ticks==3);
    services_poll(1000);
    assert(tcp_ticks==3 && arp_ticks==2 && reass_ticks==2 && link_ticks==2);
    next_tcp_timer=next_link_timer=next_arp_timer=next_reass_timer=next_rx_timer=0xfffffff0U;
    services_poll(0xfffffff0U);
    services_poll(0x54U);
    assert(tcp_ticks==4 && arp_ticks==3 && reass_ticks==3 && rx_ticks==6);
    services_poll(0x3d8U);
    assert(tcp_ticks==5 && arp_ticks==4 && reass_ticks==4 && link_ticks==4);
    make(meta,LINK_IMAGE_META,7); make(data,LINK_IMAGE_DATA,7); make(uart,LINK_UART,7);
    link_put32(meta+24,crc32(data+24,4));
    reset(); input_record(meta); input_record(data); tcp_service();
    assert(credit==60 && upload_active && link_pending(0,123,7)==2);
    assert(link_enqueue(uart,28)==1);
    for(i=0;i<2000;++i) link_poll(i*100);
    assert(upload_failed && link_failures==2);
    tcp_service(); assert(!upload_active && output[185]==5);

    // A same-key UART failure must not turn an acknowledged image into failure.
    reset(); input_record(meta); input_record(data); tcp_service();
    acknowledge(meta); acknowledge(data); assert(link_enqueue(uart,28)==1);
    for(i=0;i<=500;++i) link_poll(i*100);
    assert(link_failures==1 && !upload_failed);
    out_wr=TCP_RING; tcp_service(); assert(upload_active); // completion backpressure
    out_wr=out_rd=0; tcp_service(); assert(!upload_active && output[185]==6);

    // Disconnect cancels images but preserves unrelated UART work.
    reset(); input_record(meta); tcp_service(); assert(link_enqueue(uart,28)==1);
    disconnected(0,0); assert(!upload_active && link_pending(0,123,7)==0);
    assert(link_free(LINK_UART)==31);

    // A failed metadata packet still allows TCP input to drain to the status read.
    reset(); input_record(meta); tcp_service();
    for(i=0;i<=500;++i) link_poll(i*100);
    input_record(data); tcp_service();
    assert(credit==60 && !upload_active && output[185]==5 && !link_pending(0,123,7));

    // Partial upload + blocked ACK queue: cancel remaining work, drain TCP,
    // and retain diagnostics even if the output ring initially has no room.
    reset(); fake_counters[3]=0xfffffffeU;
    input_record(meta); tcp_service(); link_receive(meta,28);
    radio_ready=0; link_poll(0); link_poll(2000);
    assert(upload_failed && !link_pending(0,123,7));
    fake_counters[3]=1;
    out_rd=0; out_wr=TCP_RING-180;
    input_record(data); tcp_service(); assert(upload_active);
    out_wr=out_rd=0; tcp_service();
    assert(!upload_active && credit==60 && output[185]==5);
    assert(output[59]==19 && link_get32(output+68)==3); // wrapping tx_failed delta
    assert(link_get32(output+6)==123 && link_get32(output+10)==7);

    // Final fragment and CRC status are accepted atomically under backpressure.
    reset(); assert(services_deliver(meta,28));
    out_wr=TCP_RING-30; out_rd=0;
    assert(!services_deliver(data,28) && image_got==0);
    out_wr=out_rd=0;
    assert(services_deliver(data,28) && image_complete && image_got==1);
    assert(out_wr==48 && output[35]==1);
    disconnected(0,0); assert(!image_active);

    // One firmware instance: TX packets and their ACKs return via the RX entry.
    // No peer instance or host echo is involved. Image output uses the same client.
    reset(); radio_loopback=1;
    input_record(meta); input_record(data); tcp_service();
    assert(out_wr==0); // No TCP software echo before radio RX.
    for(i=0;i<8;++i) {
        link_poll(i);
        if(radio_length) { link_receive(radio_packet,radio_length); radio_length=0; }
        tcp_service();
    }
    assert(!upload_active && !link_pending(0,123,7));
    assert(image_complete && image_got==1 && !memcmp(image,"test",4));
    assert(out_wr==276 && !memcmp(output+2,meta,28) && !memcmp(output+32,data,28));
    assert(output[65]==1 && output[263]==6 && link_failures==0);

    // Actual UART parser -> link TX -> RX -> UART framing, plus local enqueue status.
    reset(); radio_loopback=1;
    serial_input[0]=0xa5; serial_input[1]=0x5a;
    link_put16(serial_input+2,28); memcpy(serial_input+4,uart,28); serial_length=32;
    uart_service();
    assert(serial_written==5 && serial_output[4]==0);
    for(i=0;i<4;++i) {
        link_poll(i);
        if(radio_length) { link_receive(radio_packet,radio_length); radio_length=0; }
        uart_service();
    }
    assert(serial_written==37 && serial_output[5]==0x5a && serial_output[6]==0xa5);
    assert(link_get16(serial_output+7)==28 && !memcmp(serial_output+9,uart,28));
    assert(link_free(LINK_UART)==32 && link_delivered==1 && link_failures==0);
    puts("DMA_SINGLE_BOARD_SERVICES_PASS");
    puts("DMA_SERVICES_PASS"); return 0;
}
