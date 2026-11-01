#ifndef OFDM_LINK_H
#define OFDM_LINK_H
#include <stdint.h>
#define LINK_HEADER 24
#define LINK_PAYLOAD 1000
#define LINK_MAX_PACKET 1024
#define LINK_UART 1
#define LINK_IMAGE_META 2
#define LINK_IMAGE_DATA 3
#define LINK_ACK 4
typedef int (*link_send_fn)(const uint8_t *, unsigned, uint32_t);
// Delivery must copy data before return. Return 0 to apply backpressure (no ACK).
typedef int (*link_deliver_fn)(const uint8_t *, unsigned);
typedef void (*link_failure_fn)(const uint8_t *, unsigned);
void link_init(link_send_fn send, link_deliver_fn deliver);
void link_set_failure_handler(link_failure_fn failed);
void link_cancel_image(uint8_t channel, uint32_t session, uint32_t message);
int link_validate(const uint8_t *p, unsigned n);
int link_enqueue(const uint8_t *p, unsigned n);
void link_receive(const uint8_t *p, unsigned n);
void link_poll(uint32_t now_ms);
unsigned link_free(unsigned type);
// Image-only pending count; unrelated UART packets do not delay completion.
unsigned link_pending(uint8_t channel, uint32_t session, uint32_t message);
extern uint32_t link_retries, link_failures, link_invalid, link_delivered;
uint16_t link_get16(const uint8_t *p);
uint32_t link_get32(const uint8_t *p);
void link_put16(uint8_t *p, uint16_t v);
void link_put32(uint8_t *p, uint32_t v);
#endif