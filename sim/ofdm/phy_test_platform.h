#ifndef PHY_TEST_PLATFORM_H
#define PHY_TEST_PLATFORM_H
#include <stdint.h>
typedef uint16_t u16;
typedef uint32_t u32;
typedef struct { struct { u32 BaseAddress; } Config; } XEmacPs;
#define XST_SUCCESS 0
#define XST_FAILURE 1
#define XPAR_XEMACPS_0_BASEADDR 0xe000b000U
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_1000MBPS_DIV0 8
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_1000MBPS_DIV1 1
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_100MBPS_DIV0 8
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_100MBPS_DIV1 5
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_10MBPS_DIV0 8
#define XPAR_PS7_ETHERNET_0_ENET_SLCR_10MBPS_DIV1 50
int XEmacPs_PhyRead(XEmacPs *,u32,u32,u16 *);
int XEmacPs_PhyWrite(XEmacPs *,u32,u32,u16);
u32 Xil_In32(u32);
void Xil_Out32(u32,u32);
void xil_printf(const char *,...);
void usleep(unsigned);
u32 __wrap_phy_setup_emacps(XEmacPs *,u32);
#endif