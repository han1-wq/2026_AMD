#include "link.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static uint8_t last[1024];
static unsigned last_len, sent, delivered;
static int ready=1;
static int tx_ready=1;
static unsigned failures, failed_type, failed_id;
static void failed(const uint8_t *p,unsigned n)
{ assert(n==28); ++failures; failed_type=p[3]; failed_id=link_get32(p+10); }
static int transmit(const uint8_t *p,unsigned n,uint32_t cookie)
{ (void)cookie; if(tx_ready<=0) return tx_ready; memcpy(last,p,n); last_len=n; ++sent; return 1; }
static int deliver(const uint8_t *p,unsigned n)
{ (void)p; (void)n; if(!ready) return 0; ++delivered; return 1; }
static void make(uint8_t *p,unsigned type,unsigned id)
{
    memset(p,0,28); p[0]='O';p[1]='F';p[2]=1;p[3]=type;
    link_put32(p+6,123); link_put32(p+10,id); link_put16(p+16,1);
    link_put16(p+18,4);link_put32(p+20,4);memcpy(p+24,"test",4);
}
int main(void)
{
    uint8_t p[28], ack[25]; unsigned i;
    link_init(transmit,deliver); make(p,LINK_UART,1);
    assert(link_enqueue(p,28)==1); link_poll(0); assert(sent==1);
    assert(link_pending(0,123,1)==0); // UART does not hold image completion.
    link_poll(99); assert(sent==1);
    link_poll(100); assert(sent==2 && link_retries==1);
    link_receive(p,28);link_receive(p,28);assert(delivered==1);
    link_poll(1001);assert(last[3]==LINK_ACK && last_len==25); memcpy(ack,last,25);
    link_receive(ack,25);assert(link_free(LINK_UART)==32);
    assert(link_pending(0,123,1)==0);
    link_poll(1002); // drain second ACK
    make(p,LINK_UART,2); ready=0;link_receive(p,28);assert(delivered==1);
    ready=1;link_receive(p,28);assert(delivered==2);
    link_init(transmit,deliver);
    for(i=0;i<24;++i) {make(p,LINK_IMAGE_DATA,i);assert(link_enqueue(p,28)==1);}
    assert(link_enqueue(p,28)==0);make(p,LINK_UART,100);assert(link_enqueue(p,28)==1);
    link_poll(0);assert(last[3]==LINK_UART);
    make(p,LINK_UART,100);p[18]=5;assert(!link_validate(p,28));
    assert(!link_validate(NULL,28));
    make(p,LINK_IMAGE_META,1);link_put16(p+16,2);assert(!link_validate(p,28));
    link_init(transmit,deliver); make(p,LINK_UART,1); assert(link_enqueue(p,28)==1);
    tx_ready=0; i=sent; link_poll(0); assert(sent==i && link_retries==0);
    tx_ready=1;
    link_set_failure_handler(failed);
    for(i=0;i<=50;++i) link_poll(i*100);
    assert(link_failures==1 && link_retries==49 && link_pending(0,123,1)==0);
    assert(failures==1 && failed_type==LINK_UART && failed_id==1);
    link_init(transmit,deliver); link_set_failure_handler(failed);
    make(p,LINK_IMAGE_DATA,2); assert(link_enqueue(p,28)==1);
    assert(link_pending(0,123,2)==1 && link_pending(1,123,2)==0);
    for(i=0;i<=50;++i) link_poll(i*100);
    assert(failures==2 && failed_type==LINK_IMAGE_DATA && failed_id==2);
    link_init(transmit,deliver);
    make(p,LINK_IMAGE_META,3); assert(link_enqueue(p,28)==1);
    make(p,LINK_IMAGE_DATA,3); assert(link_enqueue(p,28)==1);
    make(p,LINK_UART,3); assert(link_enqueue(p,28)==1);
    make(p,LINK_IMAGE_DATA,4); assert(link_enqueue(p,28)==1);
    link_cancel_image(1,123,3); assert(link_pending(0,123,3)==2);
    link_cancel_image(0,124,3); assert(link_pending(0,123,3)==2);
    link_cancel_image(0,123,3);
    assert(link_pending(0,123,3)==0 && link_pending(0,123,4)==1);
    assert(link_free(LINK_UART)==30 && link_failures==0);
    make(p,LINK_UART,1);
    link_init(transmit,deliver); assert(link_enqueue(p,28)==1);
    link_poll(0xfffffff0U); i=sent; link_poll(83); assert(sent==i);
    link_poll(84); assert(sent==i+1);
    // An ACK received before the 100 ms deadline prevents retransmission.
    link_init(transmit,deliver); assert(link_enqueue(p,28)==1);
    link_poll(0); i=sent; link_poll(50); assert(sent==i);
    link_receive(ack,25); link_poll(100);
    assert(sent==i && link_retries==0 && link_free(LINK_UART)==32);
    // A blocked ACK used to bypass every data retry/failure check indefinitely.
    link_init(transmit,deliver); link_set_failure_handler(failed);
    make(p,LINK_IMAGE_DATA,9); assert(link_enqueue(p,28)==1); link_receive(p,28);
    tx_ready=0; failures=0;
    link_poll(0xfffffff0U); link_poll(1983);
    assert(!failures && link_pending(0,123,9)==1);
    link_poll(1984);
    assert(failures==1 && link_pending(0,123,9)==0 && link_retries==0);
    // Temporary backpressure recovers, and successful submission restarts deadline.
    link_init(transmit,deliver); link_set_failure_handler(failed); failures=0;
    assert(link_enqueue(p,28)==1); link_poll(0); link_poll(1999); assert(!failures);
    tx_ready=1; link_poll(1999); tx_ready=0; link_poll(3998); assert(!failures);
    link_poll(3999); assert(failures==1);
    // A permanent submission error is surfaced immediately.
    link_init(transmit,deliver); link_set_failure_handler(failed); failures=0;
    assert(link_enqueue(p,28)==1); tx_ready=-1; link_poll(0); assert(failures==1);
    puts("DMA_LINK_PASS");return 0;
}