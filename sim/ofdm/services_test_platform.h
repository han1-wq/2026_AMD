/* Minimal platform declarations for exercising the real service state machine.
 * Unused board initialization/UART sections are removed by --gc-sections. */
#ifndef SERVICES_TEST_PLATFORM_H
#define SERVICES_TEST_PLATFORM_H
#include <stdint.h>
#include <stddef.h>
typedef int err_t;
typedef unsigned ip_addr_t;
typedef uint64_t XTime;
typedef void (*Xil_ExceptionHandler)(void *);
struct netif { int unused; };
struct tcp_pcb { int unused; };
struct pbuf { unsigned tot_len; };
#define ERR_OK 0
#define ERR_MEM -1
#define ERR_ABRT -2
#define TCP_WRITE_FLAG_COPY 1
#define IP_REASSEMBLY 1
#define IP_ADDR_ANY NULL
#define IP4_ADDR(p,a,b,c,d) (*(p)=(d))
#define XPAR_PS7_UART_1_BASEADDR 0
#define XPAR_SCUGIC_SINGLE_DEVICE_ID 0
#define XPAR_XEMACPS_0_BASEADDR 0
#define XUARTPS_FIFO_OFFSET 0
#define XST_SUCCESS 0
#define XIL_EXCEPTION_ID_IRQ_INT 0
#define COUNTS_PER_SECOND 1000000
void tcp_recv(struct tcp_pcb *,err_t (*)(void *,struct tcp_pcb *,struct pbuf *,err_t));
void tcp_err(struct tcp_pcb *,void (*)(void *,err_t));
err_t tcp_close(struct tcp_pcb *);
void tcp_abort(struct tcp_pcb *);
void tcp_recved(struct tcp_pcb *,unsigned);
unsigned tcp_sndbuf(struct tcp_pcb *);
err_t tcp_write(struct tcp_pcb *,const void *,unsigned,unsigned);
err_t tcp_output(struct tcp_pcb *);
void tcp_nagle_disable(struct tcp_pcb *);
void pbuf_free(struct pbuf *);
uint8_t pbuf_get_at(struct pbuf *,unsigned);
struct tcp_pcb *tcp_new(void);
err_t tcp_bind(struct tcp_pcb *,const ip_addr_t *,unsigned);
struct tcp_pcb *tcp_listen(struct tcp_pcb *);
void tcp_accept(struct tcp_pcb *,err_t (*)(void *,struct tcp_pcb *,err_t));
int XUartPs_IsReceiveData(unsigned);
int XUartPs_IsTransmitFull(unsigned);
uint32_t XUartPs_ReadReg(unsigned,unsigned);
void XUartPs_WriteReg(unsigned,unsigned,unsigned);
void Xil_ExceptionInit(void);
int XScuGic_DeviceInitialize(unsigned);
void Xil_ExceptionRegisterHandler(unsigned,Xil_ExceptionHandler,void *);
void XScuGic_DeviceInterruptHandler(void *);
void Xil_ExceptionEnable(void);
void lwip_init(void);
void *xemac_add(struct netif *,ip_addr_t *,ip_addr_t *,ip_addr_t *,uint8_t *,unsigned);
void netif_set_default(struct netif *);
void netif_set_up(struct netif *);
void xemacif_input(struct netif *);
void eth_link_detect(struct netif *);
void etharp_tmr(void);
void ip_reass_tmr(void);
void xemacpsif_resetrx_on_no_rxdata(struct netif *);
void XTime_GetTime(XTime *);
void xil_printf(const char *,...);
#endif