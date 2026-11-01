#ifndef OFDM_DMA_TRANSPORT_H
#define OFDM_DMA_TRANSPORT_H
#include <stdint.h>
typedef void (*dma_receive_fn)(const uint8_t *, unsigned);
#define DMA_COUNTER_COUNT 8
void dma_transport_counters(uint32_t values[DMA_COUNTER_COUNT]);
int dma_transport_init(dma_receive_fn receive);
int dma_transport_send(const uint8_t *packet, unsigned length, uint32_t cookie);
int dma_transport_poll(void);
#endif