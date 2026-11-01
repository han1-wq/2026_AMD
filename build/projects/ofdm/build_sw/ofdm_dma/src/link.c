#include "link.h"
#include <string.h>
#define WINDOW 32
#define UART_RESERVE 8
#define ACK_COUNT 64
#define DUP_COUNT 256
// ACK deadline measured from successful DMA submission, not RF completion.
#define RETRY_MS 100
#define RETRY_LIMIT 50
// Independent of RF retries: includes starvation behind a blocked ACK queue.
#define SUBMIT_TIMEOUT_MS 2000
struct packet { uint8_t data[1024]; unsigned len, attempts; uint32_t sent, progress; int used, timed; };
static struct packet window[WINDOW];
static uint8_t acks[ACK_COUNT][24], duplicates[DUP_COUNT][24];
static unsigned ack_wr, ack_rd, dup_wr, dup_used, cursor, uart_budget;
static link_send_fn transmit;
static link_deliver_fn deliver;
static link_failure_fn failed;
uint32_t link_retries, link_failures, link_invalid, link_delivered;
uint16_t link_get16(const uint8_t *p) { return p[0] | ((uint16_t)p[1]<<8); }
uint32_t link_get32(const uint8_t *p) { return link_get16(p) | ((uint32_t)link_get16(p+2)<<16); }
void link_put16(uint8_t *p, uint16_t v) { p[0]=v; p[1]=v>>8; }
void link_put32(uint8_t *p, uint32_t v) { link_put16(p,v); link_put16(p+2,v>>16); }
static int same(const uint8_t *a, const uint8_t *b)
{
    return a[3]==b[3] && a[5]==b[5] && !memcmp(a+6,b+6,12) && !memcmp(a+20,b+20,4);
}
int link_validate(const uint8_t *p, unsigned n)
{
    unsigned type, size, index, count;
    if(!p || n<24 || n>1024 || p[0]!=0x4f || p[1]!=0x46 || p[2]!=1 || p[4]!=0) return 0;
    type=p[3]; size=link_get16(p+18); index=link_get16(p+14); count=link_get16(p+16);
    if(type<1 || type>4 || size!=n-24 || !count || index>=count || link_get32(p+20)>16U*1024*1024) return 0;
    if(type==LINK_ACK) return size==1 && p[24]>=1 && p[24]<=3;
    if(type==LINK_UART) return count==1 && index==0 && size>0 && size<=1000 && link_get32(p+20)==size;
    if(type==LINK_IMAGE_META) return size==4 && index==0 && link_get32(p+20)>0 &&
        count==(link_get32(p+20)+999)/1000;
    return size>0 && count==(link_get32(p+20)+999)/1000 &&
        size==(index+1<count ? 1000 : link_get32(p+20)-index*1000U);
}
void link_init(link_send_fn send_fn, link_deliver_fn deliver_fn)
{
    memset(window,0,sizeof(window)); ack_wr=ack_rd=dup_wr=dup_used=cursor=uart_budget=0;
    link_retries=link_failures=link_invalid=link_delivered=0; transmit=send_fn; deliver=deliver_fn; failed=0;
}
void link_set_failure_handler(link_failure_fn handler) { failed=handler; }
void link_cancel_image(uint8_t channel, uint32_t session, uint32_t message)
{
    unsigned i;
    for(i=0;i<WINDOW;++i) if(window[i].used &&
        (window[i].data[3]==LINK_IMAGE_META || window[i].data[3]==LINK_IMAGE_DATA) &&
        window[i].data[5]==channel && link_get32(window[i].data+6)==session &&
        link_get32(window[i].data+10)==message) window[i].used=0;
}
unsigned link_free(unsigned type)
{
    unsigned i, free=0, begin=type==LINK_UART ? 0 : UART_RESERVE;
    for(i=begin;i<WINDOW;++i) if(!window[i].used) ++free;
    return free;
}
unsigned link_pending(uint8_t channel, uint32_t session, uint32_t message)
{
    unsigned i, count=0;
    for(i=0;i<WINDOW;++i) if(window[i].used &&
        (window[i].data[3]==LINK_IMAGE_META || window[i].data[3]==LINK_IMAGE_DATA) && window[i].data[5]==channel &&
        link_get32(window[i].data+6)==session && link_get32(window[i].data+10)==message)
        ++count;
    return count;
}
int link_enqueue(const uint8_t *p, unsigned n)
{
    unsigned i, begin=p && n>=24 && p[3]==LINK_UART ? 0 : UART_RESERVE;
    if(!link_validate(p,n) || p[3]==LINK_ACK) return -1;
    for(i=begin;i<WINDOW;++i) if(!window[i].used) {
        memcpy(window[i].data,p,n); window[i].len=n; window[i].attempts=0;
        window[i].timed=0; window[i].used=1; return 1;
    }
    return 0;
}
void link_receive(const uint8_t *p, unsigned n)
{
    unsigned i;
    uint8_t key[24];
    if(!link_validate(p,n)) { ++link_invalid; return; }
    memcpy(key,p,24);
    if(p[3]==LINK_ACK) {
        key[3]=p[24];
        // ACK payload length differs; the correlation key excludes length.
        for(i=0;i<WINDOW;++i) if(window[i].used) {
            link_put16(key+18,link_get16(window[i].data+18));
            if(same(key,window[i].data)) window[i].used=0;
        }
        return;
    }
    if(ack_wr-ack_rd==ACK_COUNT) return;
    for(i=0;i<dup_used;++i) if(!memcmp(duplicates[i],key,24)) break;
    if(i==dup_used) {
        if(!deliver(p,n)) return;
        memcpy(duplicates[dup_wr],key,24); dup_wr=(dup_wr+1)%DUP_COUNT;
        if(dup_used<DUP_COUNT) ++dup_used;
        ++link_delivered;
    }
    memcpy(acks[ack_wr%ACK_COUNT],key,24); ++ack_wr;
}
void link_poll(uint32_t now)
{
    unsigned i, pass;
    // Run before ACK priority; persistent ACK backpressure must not hide failure.
    for(i=0;i<WINDOW;++i) {
        struct packet *q=&window[i];
        if(!q->used) continue;
        if(!q->timed) { q->progress=now; q->timed=1; }
        if((uint32_t)(now-q->progress)>=SUBMIT_TIMEOUT_MS) {
            q->used=0; ++link_failures;
            if(failed) failed(q->data,q->len);
        }
    }
    if(ack_rd!=ack_wr) {
        uint8_t p[25];
        memcpy(p,acks[ack_rd%ACK_COUNT],24); p[24]=p[3]; p[3]=LINK_ACK; link_put16(p+18,1);
        if(transmit(p,25,0)>0) ++ack_rd;
        return;
    }
    for(pass=0;pass<2;++pass) for(i=0;i<WINDOW;++i) {
        unsigned j=(cursor+i)%WINDOW;
        struct packet *q=&window[j];
        int prefer_uart=uart_budget<3;
        if(!q->used || (q->attempts && (uint32_t)(now-q->sent)<RETRY_MS)) continue;
        if(pass==0 && ((q->data[3]==LINK_UART)!=prefer_uart)) continue;
        if(q->attempts>=RETRY_LIMIT) {
            q->used=0; ++link_failures;
            if(failed) failed(q->data,q->len);
            continue;
        }
        int result=transmit(q->data,q->len,link_get32(q->data+10));
        if(result>0) {
            if(q->attempts) ++link_retries;
            ++q->attempts; q->sent=q->progress=now; cursor=(j+1)%WINDOW;
            uart_budget=q->data[3]==LINK_UART ? uart_budget+1 : 0;
        } else if(result<0) {
            q->used=0; ++link_failures;
            if(failed) failed(q->data,q->len);
        }
        return;
    }
}