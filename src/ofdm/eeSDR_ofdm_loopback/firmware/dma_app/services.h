#ifndef OFDM_SERVICES_H
#define OFDM_SERVICES_H
#include <stdint.h>
int services_init(void);
void services_poll(uint32_t now);
int services_deliver(const uint8_t *packet, unsigned length);
void dma_application_run(void);
#endif