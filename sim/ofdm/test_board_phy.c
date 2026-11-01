#include "phy_test_platform.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static u16 regs[32];
static unsigned reads, writes, waits, clock_writes, fallback, bmsr_reads;
static unsigned fail_read, fail_write;
static u32 clock_value;
static XEmacPs mac={{XPAR_XEMACPS_0_BASEADDR}};

int XEmacPs_PhyRead(XEmacPs *m,u32 address,u32 reg,u16 *value)
{
    (void)m; assert(address==1 && reg<32);
    if (++reads==fail_read) return XST_FAILURE;
    *value=regs[reg];
    if (reg==1 && ++bmsr_reads==1) *value &= ~4U;
    return XST_SUCCESS;
}
int XEmacPs_PhyWrite(XEmacPs *m,u32 address,u32 reg,u16 value)
{
    (void)m; assert(address==1 && reg<32);
    if (++writes==fail_write) return XST_FAILURE;
    regs[reg]=value;
    return XST_SUCCESS;
}
u32 Xil_In32(u32 address) { assert(address==0xf8000140U); return clock_value; }
void Xil_Out32(u32 address,u32 value)
{
    ++clock_writes;
    if (address==0xf8000140U) clock_value=value;
    else assert((address==0xf8000008U && value==0xdf0dU) ||
                (address==0xf8000004U && value==0x767bU));
}
void xil_printf(const char *format,...) { (void)format; }
void usleep(unsigned delay) { assert(delay==100000); ++waits; }
u32 __real_phy_setup_emacps(XEmacPs *m,u32 address)
{ (void)m; assert(address==1); ++fallback; return 100; }
static void reset(void)
{
    memset(regs,0,sizeof(regs));
    regs[2]=0x001c; regs[3]=0xc916; regs[1]=0x79ad;
    regs[4]=0x0de1; regs[5]=0xcde1; regs[9]=0x0200; regs[10]=0x0800;
    reads=writes=waits=clock_writes=fallback=bmsr_reads=fail_read=fail_write=0;
    clock_value=0x00100801;
}
int main(void)
{
    unsigned i;
    reset(); assert(__wrap_phy_setup_emacps(&mac,1)==1000);
    assert(waits==1 && bmsr_reads==2 && regs[31]==0 && !fallback);
    assert(clock_value==0x00100801 && clock_writes==3);
    assert(!(regs[4]&0x02a0) && !(regs[9]&0x0100));
    reset(); regs[10]=0; assert(__wrap_phy_setup_emacps(&mac,1)==100);
    assert(clock_value==0x00500801);
    reset(); regs[10]=0; regs[5]=0x0041;
    assert(__wrap_phy_setup_emacps(&mac,1)==10 && clock_value==0x03200801);
    reset(); regs[10]=0; regs[5]=0x0021;
    assert(__wrap_phy_setup_emacps(&mac,1)==XST_FAILURE && clock_writes==0);
    reset(); regs[1]=0x0020;
    assert(__wrap_phy_setup_emacps(&mac,1)==XST_FAILURE && waits==100 && clock_writes==0);
    reset(); regs[3]=0xc915;
    assert(__wrap_phy_setup_emacps(&mac,1)==100 && fallback==1 && writes==0);
    for (i=1;i<=11;++i) {
        reset(); fail_read=i;
        assert(__wrap_phy_setup_emacps(&mac,1)==XST_FAILURE && clock_writes==0);
    }
    for (i=1;i<=4;++i) {
        reset(); fail_write=i;
        assert(__wrap_phy_setup_emacps(&mac,1)==XST_FAILURE && clock_writes==0);
    }
    reset(); clock_value|=0x40;
    assert(__wrap_phy_setup_emacps(&mac,1)==1000 && clock_writes==0);
    puts("BOARD_PHY_PASS");
    return 0;
}