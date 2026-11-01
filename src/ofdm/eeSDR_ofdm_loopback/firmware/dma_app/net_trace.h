#ifndef OFDM_NET_TRACE_H
#define OFDM_NET_TRACE_H
#if defined(OFDM_NET_TRACE) && !defined(OFDM_SERVICES_TEST)
struct netif;
void net_trace_init(struct netif *netif);
#else
#define net_trace_init(netif) ((void)(netif))
#endif
#endif