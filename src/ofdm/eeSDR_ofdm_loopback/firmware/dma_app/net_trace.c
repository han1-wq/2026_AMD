/* Optional RAM-only Ethernet header trace. Read with JTAG AFTER a test.
 * No serial output, allocation, or JTAG polling on the measured path.
 * TX headers precede hardware checksum insertion; they are not wire captures.
 */
#ifdef OFDM_NET_TRACE
#include "net_trace.h"
#include "lwip/netif.h"
#include "lwip/pbuf.h"
#include "xtime_l.h"
#include <stdint.h>
#include <string.h>

struct net_trace_entry {
    uint32_t us, direction, length, copied;
    uint8_t header[64];
};
struct net_trace_entry ofdm_net_trace[4096];
uint32_t ofdm_net_trace_count, ofdm_net_trace_overflow;
static netif_input_fn original_input;
static netif_linkoutput_fn original_output;

static void record(struct pbuf *p,uint32_t direction)
{
    struct net_trace_entry *e;
    XTime now;
    if(ofdm_net_trace_count>=4096) { ++ofdm_net_trace_overflow; return; }
    e=&ofdm_net_trace[ofdm_net_trace_count++];
    XTime_GetTime(&now);
    e->us=(uint32_t)(now/(COUNTS_PER_SECOND/1000000));
    e->direction=direction; e->length=p->tot_len;
    memset(e->header,0,sizeof(e->header));
    e->copied=pbuf_copy_partial(p,e->header,sizeof(e->header),0);
}
static err_t traced_input(struct pbuf *p,struct netif *netif)
{
    record(p,0);
    return original_input(p,netif);
}
static err_t traced_output(struct netif *netif,struct pbuf *p)
{
    record(p,1);
    return original_output(netif,p);
}
void net_trace_init(struct netif *netif)
{
    original_input=netif->input; original_output=netif->linkoutput;
    ofdm_net_trace_count=ofdm_net_trace_overflow=0;
    netif->input=traced_input; netif->linkoutput=traced_output;
}
#endif