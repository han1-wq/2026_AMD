#include "dma_transport.h"
#include "xaxidma.h"
#include "xil_cache.h"
#include "xil_io.h"
#include "xparameters.h"
#include <string.h>

#define COUNT 128
#define SLOT 2048
#define AHEAD 4
#define PACKET_REG 0x43c10000U
static XAxiDma dma;
static uint8_t tx_bd[COUNT * XAXIDMA_BD_MINIMUM_ALIGNMENT] __attribute__((aligned(64)));
static uint8_t rx_bd[COUNT * XAXIDMA_BD_MINIMUM_ALIGNMENT] __attribute__((aligned(64)));
static uint8_t tx_data[COUNT][SLOT] __attribute__((aligned(64)));
static uint8_t rx_data[COUNT][SLOT] __attribute__((aligned(64)));
static unsigned tx_next, rx_next, outstanding;
static dma_receive_fn receive_packet;
static int fault;

void dma_transport_counters(uint32_t values[DMA_COUNTER_COUNT])
{
    static const unsigned offsets[DMA_COUNTER_COUNT]={0x10,0x14,0x18,0x1c,0x24,0x28,0x2c,0x30};
    unsigned i;
    for(i=0;i<DMA_COUNTER_COUNT;++i) values[i]=Xil_In32(PACKET_REG+offsets[i]);
}

static int replenish(unsigned count)
{
    XAxiDma_BdRing *r = XAxiDma_GetRxRing(&dma);
    XAxiDma_Bd *first, *b;
    unsigned i;
    if (!count) return 0;
    if (XAxiDma_BdRingAlloc(r, count, &first) != XST_SUCCESS) return -1;
    b = first;
    for (i = 0; i < count; ++i) {
        uint8_t *p = rx_data[rx_next];
        rx_next = (rx_next + 1) % COUNT;
        Xil_DCacheFlushRange((UINTPTR)p, SLOT);
        if (XAxiDma_BdSetBufAddr(b, (UINTPTR)p) != XST_SUCCESS ||
            XAxiDma_BdSetLength(b, SLOT, r->MaxTransferLen) != XST_SUCCESS) return -1;
        XAxiDma_BdSetCtrl(b, 0);
        XAxiDma_BdSetId(b, (UINTPTR)p);
        b = (XAxiDma_Bd *)(UINTPTR)XAxiDma_BdRingNext(r, b);
    }
    return XAxiDma_BdRingToHw(r, count, first) == XST_SUCCESS ? 0 : -1;
}

int dma_transport_init(dma_receive_fn receive)
{
    XAxiDma_Config *cfg = XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
    XAxiDma_BdRing *r;
    XAxiDma_Bd zero;
    unsigned i;
    Xil_Out32(PACKET_REG + 4, 0);
    if (Xil_In32(PACKET_REG) != 0x444d4101U || !cfg ||
        XAxiDma_CfgInitialize(&dma, cfg) != XST_SUCCESS || !XAxiDma_HasSg(&dma)) return -1;
    receive_packet = receive;
    tx_next = rx_next = outstanding = 0;
    fault = 0;
    XAxiDma_BdClear(&zero);
    for (i = 0; i < 2; ++i) {
        UINTPTR base = (UINTPTR)(i ? rx_bd : tx_bd);
        r = i ? XAxiDma_GetRxRing(&dma) : XAxiDma_GetTxRing(&dma);
        XAxiDma_BdRingIntDisable(r, XAXIDMA_IRQ_ALL_MASK);
        if (XAxiDma_BdRingCreate(r, base, base, XAXIDMA_BD_MINIMUM_ALIGNMENT, COUNT) != XST_SUCCESS ||
            XAxiDma_BdRingClone(r, &zero) != XST_SUCCESS) return -1;
    }
    if (replenish(COUNT) || XAxiDma_BdRingStart(XAxiDma_GetRxRing(&dma)) != XST_SUCCESS ||
        XAxiDma_BdRingStart(XAxiDma_GetTxRing(&dma)) != XST_SUCCESS) return -1;
    Xil_Out32(PACKET_REG + 4, 1);
    return 0;
}

int dma_transport_send(const uint8_t *packet, unsigned length, uint32_t cookie)
{
    XAxiDma_BdRing *r = XAxiDma_GetTxRing(&dma);
    XAxiDma_Bd *b;
    uint8_t *p;
    if (fault || !length || length > 1024) return -1;
    if (outstanding >= AHEAD) return 0;
    // Include packets already copied out by DMA but still waiting for OFDM.
    if ((uint32_t)(Xil_In32(PACKET_REG+0x10) - Xil_In32(PACKET_REG+0x14) -
                   Xil_In32(PACKET_REG+0x1c)) >= AHEAD) return 0;
    if (XAxiDma_BdRingAlloc(r, 1, &b) != XST_SUCCESS) return 0;
    p = tx_data[tx_next];
    memset(p, 0, 16);
    p[0] = length; p[1] = length >> 8; p[2] = 54;
    p[4] = cookie; p[5] = cookie >> 8; p[6] = cookie >> 16; p[7] = cookie >> 24;
    memcpy(p + 16, packet, length);
    Xil_DCacheFlushRange((UINTPTR)p, SLOT);
    if (XAxiDma_BdSetBufAddr(b, (UINTPTR)p) != XST_SUCCESS ||
        XAxiDma_BdSetLength(b, length + 16, r->MaxTransferLen) != XST_SUCCESS) {
        XAxiDma_BdRingUnAlloc(r, 1, b); return -1;
    }
    XAxiDma_BdSetCtrl(b, XAXIDMA_BD_CTRL_TXSOF_MASK | XAXIDMA_BD_CTRL_TXEOF_MASK);
    XAxiDma_BdSetId(b, (UINTPTR)p);
    if (XAxiDma_BdRingToHw(r, 1, b) != XST_SUCCESS) { fault = 1; return -1; }
    tx_next = (tx_next + 1) % COUNT;
    ++outstanding;
    return 1;
}

int dma_transport_poll(void)
{
    unsigned side;
    if (fault) return -1;
    for (side = 0; side < 2; ++side) {
        XAxiDma_BdRing *r = side ? XAxiDma_GetRxRing(&dma) : XAxiDma_GetTxRing(&dma);
        XAxiDma_Bd *first, *b;
        int n, i;
        if (XAxiDma_BdRingGetIrq(r) & XAXIDMA_IRQ_ERROR_MASK) { fault = 1; return -1; }
        n = XAxiDma_BdRingFromHw(r, 32, &first);
        b = first;
        for (i = 0; i < n; ++i) {
            uint32_t status = XAxiDma_BdGetSts(b);
            if (status & XAXIDMA_BD_STS_ALL_ERR_MASK) { fault = 1; return -1; }
            if (side) {
                unsigned length = XAxiDma_BdGetActualLength(b, r->MaxTransferLen);
                uint8_t *p = (uint8_t *)(UINTPTR)XAxiDma_BdGetId(b);
                if (length > 1024 || !length ||
                    (status & (XAXIDMA_BD_STS_RXSOF_MASK | XAXIDMA_BD_STS_RXEOF_MASK)) !=
                    (XAXIDMA_BD_STS_RXSOF_MASK | XAXIDMA_BD_STS_RXEOF_MASK)) { fault = 1; return -1; }
                Xil_DCacheInvalidateRange((UINTPTR)p, SLOT);
                receive_packet(p, length);
            } else --outstanding;
            b = (XAxiDma_Bd *)(UINTPTR)XAxiDma_BdRingNext(r, b);
        }
        if (n && XAxiDma_BdRingFree(r, n, first) != XST_SUCCESS) { fault = 1; return -1; }
        if (side && replenish(n)) { fault = 1; return -1; }
    }
    return 0;
}