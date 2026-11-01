/* RTL8211F (001c:c916) adaptation for the Zynq GEM0 on this board.
 * lwip211 v1.7 tests RTL8211E's vendor register 17, which is not the
 * RTL8211F status register. Resolve full-duplex speed from Clause 22
 * advertisement registers instead. Link with --wrap=phy_setup_emacps so
 * BSP regeneration cannot silently discard this board adaptation.
 */
#ifdef OFDM_PHY_TEST
#include "phy_test_platform.h"
#else
#include "xemacps.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "sleep.h"
#endif

extern u32 __real_phy_setup_emacps(XEmacPs *mac, u32 address);

static u32 rtl8211f_speed(XEmacPs *mac, u32 address)
{
    u16 control, status, local, peer, gig_local, gig_peer;
    unsigned tries;
    /* Standard registers are available on page zero. Leave page zero for
     * lwIP's periodic link polling as well. Advertise full duplex only,
     * matching the GEM configuration used by the standalone adapter. */
    if (XEmacPs_PhyWrite(mac,address,31,0) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,4,&local) != XST_SUCCESS ||
        XEmacPs_PhyWrite(mac,address,4,(local & ~0x03e0U) | 0x0140U) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,9,&gig_local) != XST_SUCCESS ||
        XEmacPs_PhyWrite(mac,address,9,(gig_local & ~0x0300U) | 0x0200U) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,0,&control) != XST_SUCCESS ||
        XEmacPs_PhyWrite(mac,address,0,(control & ~0x0c00U) | 0x1200U) != XST_SUCCESS)
        return XST_FAILURE;
    for (tries=0; tries<100; ++tries) {
        usleep(100000);
        /* BMSR link is latched low: read twice. */
        if (XEmacPs_PhyRead(mac,address,1,&status) != XST_SUCCESS ||
            XEmacPs_PhyRead(mac,address,1,&status) != XST_SUCCESS)
            return XST_FAILURE;
        if ((status & 0x0024U) == 0x0024U) break;
    }
    if (tries == 100 ||
        XEmacPs_PhyRead(mac,address,4,&local) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,5,&peer) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,9,&gig_local) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,10,&gig_peer) != XST_SUCCESS)
        return XST_FAILURE;
    if ((gig_local & 0x0200U) && (gig_peer & 0x0800U)) return 1000;
    if (local & peer & 0x0100U) return 100;
    if (local & peer & 0x0040U) return 10;
    return XST_FAILURE;
}

u32 __wrap_phy_setup_emacps(XEmacPs *mac, u32 address)
{
    u16 id1, id2;
    u32 speed, div0, div1, clock;
    if (XEmacPs_PhyRead(mac,address,2,&id1) != XST_SUCCESS ||
        XEmacPs_PhyRead(mac,address,3,&id2) != XST_SUCCESS)
        return XST_FAILURE;
    if (id1 != 0x001c || id2 != 0xc916 ||
        mac->Config.BaseAddress != XPAR_XEMACPS_0_BASEADDR)
        return __real_phy_setup_emacps(mac,address);
    speed=rtl8211f_speed(mac,address);
    if (speed == XST_FAILURE) {
        xil_printf("RTL8211F: negotiation/read failed at PHY %d\r\n",address);
        return speed;
    }
    if (speed == 1000) {
        div0=XPAR_PS7_ETHERNET_0_ENET_SLCR_1000MBPS_DIV0;
        div1=XPAR_PS7_ETHERNET_0_ENET_SLCR_1000MBPS_DIV1;
    } else if (speed == 100) {
        div0=XPAR_PS7_ETHERNET_0_ENET_SLCR_100MBPS_DIV0;
        div1=XPAR_PS7_ETHERNET_0_ENET_SLCR_100MBPS_DIV1;
    } else {
        div0=XPAR_PS7_ETHERNET_0_ENET_SLCR_10MBPS_DIV0;
        div1=XPAR_PS7_ETHERNET_0_ENET_SLCR_10MBPS_DIV1;
    }
    clock=Xil_In32(0xf8000140U);
    if (!(clock & 0x40U)) {
        Xil_Out32(0xf8000008U,0xdf0dU);
        Xil_Out32(0xf8000140U,(clock & 0xfc0fc0ffU) | (div0<<8) | (div1<<20));
        Xil_Out32(0xf8000004U,0x767bU);
    }
    xil_printf("RTL8211F PHY %d: %d Mbps full duplex\r\n",address,speed);
    return speed;
}