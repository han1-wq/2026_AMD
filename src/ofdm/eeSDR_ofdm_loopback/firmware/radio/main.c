/***************************************************************************//**
 *   @file   main.c
 *   @brief  Implementation of Main Function.
 *   @author DBogdan (dragos.bogdan@analog.com)
 *   @Editor Week8~
 ********************************************************************************
 * Copyright 2013(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  - Neither the name of Analog Devices, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *  - The use of this software may or may not infringe the patent rights
 *    of one or more patent holders.  This license does not release you
 *    from the requirement that you obtain separate licenses from these
 *    patent holders to use this software.
 *  - Use of the software either in source or binary form, must be run
 *    on or directly connected to an Analog Devices Inc. component.
 *
 * THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *******************************************************************************/

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include "config.h"
#include "ad9361_api.h"
#include "platform.h"
#include <xil_cache.h>
#include "xil_io.h"
#include "xgpiops_hw.h"
#include "xgpiops.h"
#include "sleep.h"
#include "xuartps.h"
#include "xuartps_hw.h"
#include "xparameters.h"
#include <string.h>
#include "services.h"

//axi addr offset
#define axi_ad936x_TR_mode    		(XPAR_AXI_AD936X_CTRL_0_BASEADDR + 0U)
#define axi_DDS_PhaseInc			(XPAR_AXI_AD936X_CTRL_0_BASEADDR + 4U)
#define MAILBOX_BASE            XPAR_AD936X_OFDM_TOP_0_BASEADDR
#define MB_CONTROL              (MAILBOX_BASE + 0x00U)
#define MB_STATUS               (MAILBOX_BASE + 0x04U)
#define MB_RX_LENGTH            (MAILBOX_BASE + 0x08U)
#define MB_TX                   (MAILBOX_BASE + 0x40U)
#define MB_RX                   (MAILBOX_BASE + 0x80U)
#define UART_BASE               XPAR_PS7_UART_1_BASEADDR
#define UART_DEVICE_ID          XPAR_XUARTPS_0_DEVICE_ID
#define GPIO_DEVICE_ID				XPAR_PS7_GPIO_0_DEVICE_ID
#define ad936x_SPI_DEVICE_ID		XPAR_PS7_SPI_0_DEVICE_ID
//emio
#define EMIO_EN_AGC					54+0
#define EMIO_ENABLE					54+1
#define EMIO_RESET					54+2
#define EMIO_TXNRX        			54+3
#define EMIO_SYNC					54+4
#define EMIO_CTL0					54+5
#define EMIO_CTL1					54+6
#define EMIO_CTL2					54+7
#define EMIO_CTL3					54+8
//mio
#define MIO_LED0 					0
#define MIO_LED1 					10
//TRmode define
#define ad936x_TRmode_1T1R 			0
#define ad936x_TRmode_2T2R 			1
//temp value
uint8_t ad936x_reg_value;
int32_t status = 0;
static uint8_t u8_value_storage;
static int32_t i32_value_storage;
static uint32_t u32_value_storage;
static uint64_t u64_value_storage;
static uint8_t *const u8_value = &u8_value_storage;
static int32_t *const i32_value = &i32_value_storage;
static uint32_t *const u32_value = &u32_value_storage;
static uint64_t *const u64_value = &u64_value_storage;
static XUartPs uart_instance;

static int32_t uart_init(void)
{
	XUartPs_Config *config;
	XUartPsFormat format = {
		115200U,
		XUARTPS_FORMAT_8_BITS,
		XUARTPS_FORMAT_NO_PARITY,
		XUARTPS_FORMAT_1_STOP_BIT
	};
	int32_t result;

	config = XUartPs_LookupConfig(UART_DEVICE_ID);
	if (config == NULL)
		return XST_FAILURE;
	result = XUartPs_CfgInitialize(&uart_instance, config, UART_BASE);
	if (result != XST_SUCCESS)
		return result;
	result = XUartPs_SetDataFormat(&uart_instance, &format);
	if (result != XST_SUCCESS)
		return result;
	XUartPs_SetOptions(&uart_instance, XUARTPS_OPTION_RESET_RX |
		XUARTPS_OPTION_RESET_TX);
	XUartPs_SetOperMode(&uart_instance, XUARTPS_OPER_MODE_NORMAL);
	return XST_SUCCESS;
}
//ad936x parameter
uint32_t TRX_SamplingRate = 40000000U;//complex samples/s; data_clk=80 MHz in 1T1R
uint64_t TX_LO_Freq = 850e6;//HZ
uint64_t RX_LO_Freq = 850e6;//HZ
uint32_t TX_BandWidth = 40000000U;//HZ; 40 MS/s 64-point OFDM occupied BW 32.5 MHz
uint32_t RX_BandWidth = 40000000U;//HZ
int32_t RX_Gain_CH1 = 12;//dB
int32_t RX_Gain_CH2 = 12;//dB
uint32_t TX_Att_CH1 = 10000;//mdB
uint32_t TX_Att_CH2 = 10000;//mdB

struct ad9361_rf_phy *ad9361_phy;

AD9361_InitParam default_init_param =
{
		/* Device selection */
		ID_AD9361,	// dev_sel
		/* Identification number */
		0,		//id_no;
		/* Reference Clock */
		40000000UL,	//reference_clk_rate
		/* Base Configuration */
		0,		//two_rx_two_tx_mode_enable *** adi,2rx-2tx-mode-enable
		1,		//one_rx_one_tx_mode_use_rx_num *** adi,1rx-1tx-mode-use-rx-num
		1,		//one_rx_one_tx_mode_use_tx_num *** adi,1rx-1tx-mode-use-tx-num
		1,  	//frequency_division_duplex_mode_enable *** adi,frequency-division-duplex-mode-enable
		0,		//frequency_division_duplex_independent_mode_enable *** adi,frequency-division-duplex-independent-mode-enable
		0,		//tdd_use_dual_synth_mode_enable *** adi,tdd-use-dual-synth-mode-enable
		0,		//tdd_skip_vco_cal_enable *** adi,tdd-skip-vco-cal-enable
		0,		//tx_fastlock_delay_ns *** adi,tx-fastlock-delay-ns
		0,		//rx_fastlock_delay_ns *** adi,rx-fastlock-delay-ns
		0,		//rx_fastlock_pincontrol_enable *** adi,rx-fastlock-pincontrol-enable
		0,		//tx_fastlock_pincontrol_enable *** adi,tx-fastlock-pincontrol-enable
		0,		//external_rx_lo_enable *** adi,external-rx-lo-enable
		0,		//external_tx_lo_enable *** adi,external-tx-lo-enable
		5,		//dc_offset_tracking_update_event_mask *** adi,dc-offset-tracking-update-event-mask
		6,		//dc_offset_attenuation_high_range *** adi,dc-offset-attenuation-high-range
		5,		//dc_offset_attenuation_low_range *** adi,dc-offset-attenuation-low-range
		0x28,	//dc_offset_count_high_range *** adi,dc-offset-count-high-range
		0x32,	//dc_offset_count_low_range *** adi,dc-offset-count-low-range
		0,		//split_gain_table_mode_enable *** adi,split-gain-table-mode-enable
		MAX_SYNTH_FREF,	//trx_synthesizer_target_fref_overwrite_hz *** adi,trx-synthesizer-target-fref-overwrite-hz
		0,		// qec_tracking_slow_mode_enable *** adi,qec-tracking-slow-mode-enable
		/* ENSM Control */
		0,		//ensm_enable_pin_pulse_mode_enable *** adi,ensm-enable-pin-pulse-mode-enable
		0,		//ensm_enable_txnrx_control_enable *** adi,ensm-enable-txnrx-control-enable
		/* LO Control */
		2400000000UL,	//rx_synthesizer_frequency_hz *** adi,rx-synthesizer-frequency-hz
		2400000000UL,	//tx_synthesizer_frequency_hz *** adi,tx-synthesizer-frequency-hz
		1,				//tx_lo_powerdown_managed_enable *** adi,tx-lo-powerdown-managed-enable
		/* Rate & BW Control */
		{1280000000,320000000,160000000,80000000,40000000,40000000 },	//uint32_t	rx_path_clock_frequencies[6] *** adi,rx-path-clock-frequencies
		{1280000000,160000000,160000000,80000000,40000000,40000000 },	//uint32_t	tx_path_clock_frequencies[6] *** adi,tx-path-clock-frequencies
		20000000,//rf_rx_bandwidth_hz *** adi,rf-rx-bandwidth-hz
		20000000,//rf_tx_bandwidth_hz *** adi,rf-tx-bandwidth-hz
		/* RF Port Control */
		0,		//rx_rf_port_input_select *** adi,rx-rf-port-input-select
		0,		//tx_rf_port_input_select *** adi,tx-rf-port-input-select
		/* TX Attenuation Control */
		10000,	//tx_attenuation_mdB *** adi,tx-attenuation-mdB
		0,		//update_tx_gain_in_alert_enable *** adi,update-tx-gain-in-alert-enable
		/* Reference Clock Control */
		0,		//xo_disable_use_ext_refclk_enable *** adi,xo-disable-use-ext-refclk-enable
		{8, 5920},	//dcxo_coarse_and_fine_tune[2] *** adi,dcxo-coarse-and-fine-tune
		0,	//clk_output_mode_select *** adi,clk-output-mode-select
		/* Gain Control */
		0,		//gc_rx1_mode *** adi,gc-rx1-mode
		0,		//gc_rx2_mode *** adi,gc-rx2-mode
		58,		//gc_adc_large_overload_thresh *** adi,gc-adc-large-overload-thresh
		4,		//gc_adc_ovr_sample_size *** adi,gc-adc-ovr-sample-size
		47,		//gc_adc_small_overload_thresh *** adi,gc-adc-small-overload-thresh
		8192,	//gc_dec_pow_measurement_duration *** adi,gc-dec-pow-measurement-duration
		0,		//gc_dig_gain_enable *** adi,gc-dig-gain-enable
		800,//gc_lmt_overload_high_thresh *** adi,gc-lmt-overload-high-thresh
		704,	//gc_lmt_overload_low_thresh *** adi,gc-lmt-overload-low-thresh
		24,		//gc_low_power_thresh *** adi,gc-low-power-thresh
		15,		//gc_max_dig_gain *** adi,gc-max-dig-gain
		/* Gain MGC Control */
		2,		//mgc_dec_gain_step *** adi,mgc-dec-gain-step
		2,		//mgc_inc_gain_step *** adi,mgc-inc-gain-step
		0,		//mgc_rx1_ctrl_inp_enable *** adi,mgc-rx1-ctrl-inp-enable
		0,		//mgc_rx2_ctrl_inp_enable *** adi,mgc-rx2-ctrl-inp-enable
		0,		//mgc_split_table_ctrl_inp_gain_mode *** adi,mgc-split-table-ctrl-inp-gain-mode
		/* Gain AGC Control */
		10,		//agc_adc_large_overload_exceed_counter *** adi,agc-adc-large-overload-exceed-counter
		2,		//agc_adc_large_overload_inc_steps *** adi,agc-adc-large-overload-inc-steps
		0,		//agc_adc_lmt_small_overload_prevent_gain_inc_enable *** adi,agc-adc-lmt-small-overload-prevent-gain-inc-enable
		10,		//agc_adc_small_overload_exceed_counter *** adi,agc-adc-small-overload-exceed-counter
		4,		//agc_dig_gain_step_size *** adi,agc-dig-gain-step-size
		3,		//agc_dig_saturation_exceed_counter *** adi,agc-dig-saturation-exceed-counter
		1000,	// agc_gain_update_interval_us *** adi,agc-gain-update-interval-us
		0,		//agc_immed_gain_change_if_large_adc_overload_enable *** adi,agc-immed-gain-change-if-large-adc-overload-enable
		0,		//agc_immed_gain_change_if_large_lmt_overload_enable *** adi,agc-immed-gain-change-if-large-lmt-overload-enable
		10,		//agc_inner_thresh_high *** adi,agc-inner-thresh-high
		1,		//agc_inner_thresh_high_dec_steps *** adi,agc-inner-thresh-high-dec-steps
		12,		//agc_inner_thresh_low *** adi,agc-inner-thresh-low
		1,		//agc_inner_thresh_low_inc_steps *** adi,agc-inner-thresh-low-inc-steps
		10,		//agc_lmt_overload_large_exceed_counter *** adi,agc-lmt-overload-large-exceed-counter
		2,		//agc_lmt_overload_large_inc_steps *** adi,agc-lmt-overload-large-inc-steps
		10,		//agc_lmt_overload_small_exceed_counter *** adi,agc-lmt-overload-small-exceed-counter
		5,		//agc_outer_thresh_high *** adi,agc-outer-thresh-high
		2,		//agc_outer_thresh_high_dec_steps *** adi,agc-outer-thresh-high-dec-steps
		18,		//agc_outer_thresh_low *** adi,agc-outer-thresh-low
		2,		//agc_outer_thresh_low_inc_steps *** adi,agc-outer-thresh-low-inc-steps
		1,		//agc_attack_delay_extra_margin_us; *** adi,agc-attack-delay-extra-margin-us
		0,		//agc_sync_for_gain_counter_enable *** adi,agc-sync-for-gain-counter-enable
		/* Fast AGC */
		64,		//fagc_dec_pow_measuremnt_duration ***  adi,fagc-dec-pow-measurement-duration
		260,	//fagc_state_wait_time_ns ***  adi,fagc-state-wait-time-ns
		/* Fast AGC - Low Power */
		0,		//fagc_allow_agc_gain_increase ***  adi,fagc-allow-agc-gain-increase-enable
		5,		//fagc_lp_thresh_increment_time ***  adi,fagc-lp-thresh-increment-time
		1,		//fagc_lp_thresh_increment_steps ***  adi,fagc-lp-thresh-increment-steps
		/* Fast AGC - Lock Level */
		1,		//fagc_lock_level_lmt_gain_increase_en ***  adi,fagc-lock-level-lmt-gain-increase-enable
		5,		//fagc_lock_level_gain_increase_upper_limit ***  adi,fagc-lock-level-gain-increase-upper-limit
		/* Fast AGC - Peak Detectors and Final Settling */
		1,		//fagc_lpf_final_settling_steps ***  adi,fagc-lpf-final-settling-steps
		1,		//fagc_lmt_final_settling_steps ***  adi,fagc-lmt-final-settling-steps
		3,		//fagc_final_overrange_count ***  adi,fagc-final-overrange-count
		/* Fast AGC - Final Power Test */
		0,		//fagc_gain_increase_after_gain_lock_en ***  adi,fagc-gain-increase-after-gain-lock-enable
		/* Fast AGC - Unlocking the Gain */
		0,		//fagc_gain_index_type_after_exit_rx_mode ***  adi,fagc-gain-index-type-after-exit-rx-mode
		1,		//fagc_use_last_lock_level_for_set_gain_en ***  adi,fagc-use-last-lock-level-for-set-gain-enable
		1,		//fagc_rst_gla_stronger_sig_thresh_exceeded_en ***  adi,fagc-rst-gla-stronger-sig-thresh-exceeded-enable
		5,		//fagc_optimized_gain_offset ***  adi,fagc-optimized-gain-offset
		10,		//fagc_rst_gla_stronger_sig_thresh_above_ll ***  adi,fagc-rst-gla-stronger-sig-thresh-above-ll
		1,		//fagc_rst_gla_engergy_lost_sig_thresh_exceeded_en ***  adi,fagc-rst-gla-engergy-lost-sig-thresh-exceeded-enable
		1,		//fagc_rst_gla_engergy_lost_goto_optim_gain_en ***  adi,fagc-rst-gla-engergy-lost-goto-optim-gain-enable
		10,		//fagc_rst_gla_engergy_lost_sig_thresh_below_ll ***  adi,fagc-rst-gla-engergy-lost-sig-thresh-below-ll
		8,		//fagc_energy_lost_stronger_sig_gain_lock_exit_cnt ***  adi,fagc-energy-lost-stronger-sig-gain-lock-exit-cnt
		1,		//fagc_rst_gla_large_adc_overload_en ***  adi,fagc-rst-gla-large-adc-overload-enable
		1,		//fagc_rst_gla_large_lmt_overload_en ***  adi,fagc-rst-gla-large-lmt-overload-enable
		0,		//fagc_rst_gla_en_agc_pulled_high_en ***  adi,fagc-rst-gla-en-agc-pulled-high-enable
		0,		//fagc_rst_gla_if_en_agc_pulled_high_mode ***  adi,fagc-rst-gla-if-en-agc-pulled-high-mode
		64,		//fagc_power_measurement_duration_in_state5 ***  adi,fagc-power-measurement-duration-in-state5
		/* RSSI Control */
		1,		//rssi_delay *** adi,rssi-delay
		1000,	//rssi_duration *** adi,rssi-duration
		3,		//rssi_restart_mode *** adi,rssi-restart-mode
		0,		//rssi_unit_is_rx_samples_enable *** adi,rssi-unit-is-rx-samples-enable
		1,		//rssi_wait *** adi,rssi-wait
		/* Aux ADC Control */
		256,	//aux_adc_decimation *** adi,aux-adc-decimation
		40000000UL,	//aux_adc_rate *** adi,aux-adc-rate
		/* AuxDAC Control */
		1,		//aux_dac_manual_mode_enable ***  adi,aux-dac-manual-mode-enable
		0,		//aux_dac1_default_value_mV ***  adi,aux-dac1-default-value-mV
		0,		//aux_dac1_active_in_rx_enable ***  adi,aux-dac1-active-in-rx-enable
		0,		//aux_dac1_active_in_tx_enable ***  adi,aux-dac1-active-in-tx-enable
		0,		//aux_dac1_active_in_alert_enable ***  adi,aux-dac1-active-in-alert-enable
		0,		//aux_dac1_rx_delay_us ***  adi,aux-dac1-rx-delay-us
		0,		//aux_dac1_tx_delay_us ***  adi,aux-dac1-tx-delay-us
		0,		//aux_dac2_default_value_mV ***  adi,aux-dac2-default-value-mV
		0,		//aux_dac2_active_in_rx_enable ***  adi,aux-dac2-active-in-rx-enable
		0,		//aux_dac2_active_in_tx_enable ***  adi,aux-dac2-active-in-tx-enable
		0,		//aux_dac2_active_in_alert_enable ***  adi,aux-dac2-active-in-alert-enable
		0,		//aux_dac2_rx_delay_us ***  adi,aux-dac2-rx-delay-us
		0,		//aux_dac2_tx_delay_us ***  adi,aux-dac2-tx-delay-us
		/* Temperature Sensor Control */
		256,	//temp_sense_decimation *** adi,temp-sense-decimation
		1000,	//temp_sense_measurement_interval_ms *** adi,temp-sense-measurement-interval-ms
		0xCE,	//temp_sense_offset_signed *** adi,temp-sense-offset-signed
		1,		//temp_sense_periodic_measurement_enable *** adi,temp-sense-periodic-measurement-enable
		/* Control Out Setup */
		0xFF,	//ctrl_outs_enable_mask *** adi,ctrl-outs-enable-mask
		0,		//ctrl_outs_index *** adi,ctrl-outs-index
		/* External LNA Control */
		0,		//elna_settling_delay_ns *** adi,elna-settling-delay-ns
		0,		//elna_gain_mdB *** adi,elna-gain-mdB
		0,		//elna_bypass_loss_mdB *** adi,elna-bypass-loss-mdB
		0,		//elna_rx1_gpo0_control_enable *** adi,elna-rx1-gpo0-control-enable
		0,		//elna_rx2_gpo1_control_enable *** adi,elna-rx2-gpo1-control-enable
		0,		//elna_gaintable_all_index_enable *** adi,elna-gaintable-all-index-enable
		/* Digital Interface Control */
		0,		//digital_interface_tune_skip_mode *** adi,digital-interface-tune-skip-mode
		0,		//digital_interface_tune_fir_disable *** adi,digital-interface-tune-fir-disable
		1,		//pp_tx_swap_enable *** adi,pp-tx-swap-enable
		1,		//pp_rx_swap_enable *** adi,pp-rx-swap-enable
		0,		//tx_channel_swap_enable *** adi,tx-channel-swap-enable
		0,		//rx_channel_swap_enable *** adi,rx-channel-swap-enable
		1,		//rx_frame_pulse_mode_enable *** adi,rx-frame-pulse-mode-enable
		0,		//two_t_two_r_timing_enable *** adi,2t2r-timing-enable
		0,		//invert_data_bus_enable *** adi,invert-data-bus-enable
		0,		//invert_data_clk_enable *** adi,invert-data-clk-enable
		0,		//fdd_alt_word_order_enable *** adi,fdd-alt-word-order-enable
		0,		//invert_rx_frame_enable *** adi,invert-rx-frame-enable
		0,		//fdd_rx_rate_2tx_enable *** adi,fdd-rx-rate-2tx-enable
		0,		//swap_ports_enable *** adi,swap-ports-enable
		0,		//single_data_rate_enable *** adi,single-data-rate-enable
		1,		//lvds_mode_enable *** adi,lvds-mode-enable
		0,		//half_duplex_mode_enable *** adi,half-duplex-mode-enable
		0,		//single_port_mode_enable *** adi,single-port-mode-enable
		0,		//full_port_enable *** adi,full-port-enable
		0,		//full_duplex_swap_bits_enable *** adi,full-duplex-swap-bits-enable
		0,		//delay_rx_data *** adi,delay-rx-data
		0,		//rx_data_clock_delay *** adi,rx-data-clock-delay
		4,		//rx_data_delay *** adi,rx-data-delay
		5,		//tx_fb_clock_delay *** adi,tx-fb-clock-delay
		0,		//tx_data_delay *** adi,tx-data-delay
		150,	//lvds_bias_mV *** adi,lvds-bias-mV
		1,		//lvds_rx_onchip_termination_enable *** adi,lvds-rx-onchip-termination-enable
		0,		//rx1rx2_phase_inversion_en *** adi,rx1-rx2-phase-inversion-enable
		0xFF,	//lvds_invert1_control *** adi,lvds-invert1-control
		0x0F,	//lvds_invert2_control *** adi,lvds-invert2-control
		/* GPO Control */
		0,		//gpo0_inactive_state_high_enable *** adi,gpo0-inactive-state-high-enable
		0,		//gpo1_inactive_state_high_enable *** adi,gpo1-inactive-state-high-enable
		0,		//gpo2_inactive_state_high_enable *** adi,gpo2-inactive-state-high-enable
		0,		//gpo3_inactive_state_high_enable *** adi,gpo3-inactive-state-high-enable
		0,		//gpo0_slave_rx_enable *** adi,gpo0-slave-rx-enable
		0,		//gpo0_slave_tx_enable *** adi,gpo0-slave-tx-enable
		0,		//gpo1_slave_rx_enable *** adi,gpo1-slave-rx-enable
		0,		//gpo1_slave_tx_enable *** adi,gpo1-slave-tx-enable
		0,		//gpo2_slave_rx_enable *** adi,gpo2-slave-rx-enable
		0,		//gpo2_slave_tx_enable *** adi,gpo2-slave-tx-enable
		0,		//gpo3_slave_rx_enable *** adi,gpo3-slave-rx-enable
		0,		//gpo3_slave_tx_enable *** adi,gpo3-slave-tx-enable
		0,		//gpo0_rx_delay_us *** adi,gpo0-rx-delay-us
		0,		//gpo0_tx_delay_us *** adi,gpo0-tx-delay-us
		0,		//gpo1_rx_delay_us *** adi,gpo1-rx-delay-us
		0,		//gpo1_tx_delay_us *** adi,gpo1-tx-delay-us
		0,		//gpo2_rx_delay_us *** adi,gpo2-rx-delay-us
		0,		//gpo2_tx_delay_us *** adi,gpo2-tx-delay-us
		0,		//gpo3_rx_delay_us *** adi,gpo3-rx-delay-us
		0,		//gpo3_tx_delay_us *** adi,gpo3-tx-delay-us
		/* Tx Monitor Control */
		37000,	//low_high_gain_threshold_mdB *** adi,txmon-low-high-thresh
		0,		//low_gain_dB *** adi,txmon-low-gain
		24,		//high_gain_dB *** adi,txmon-high-gain
		0,		//tx_mon_track_en *** adi,txmon-dc-tracking-enable
		0,		//one_shot_mode_en *** adi,txmon-one-shot-mode-enable
		511,	//tx_mon_delay *** adi,txmon-delay
		8192,	//tx_mon_duration *** adi,txmon-duration
		2,		//tx1_mon_front_end_gain *** adi,txmon-1-front-end-gain
		2,		//tx2_mon_front_end_gain *** adi,txmon-2-front-end-gain
		48,		//tx1_mon_lo_cm *** adi,txmon-1-lo-cm
		48 		//tx2_mon_lo_cm *** adi,txmon-2-lo-cm
		/* GPIO definitions */
};

AD9361_RXFIRConfig rx_fir_config = {
		3, // rx
		6, // rx_gain
		1, // rx_dec
		{-334,-673,299,-24,-185,297,-268,92,165,-380,433,-263,-77,435,-619,496,-75,-472,870,
				-868,381,434,-1205,1491,-991,-262,1824,-2908,2699,-497,-4646,20623,20623,-4646,
				-497,2699,-2908,1824,-262,-991,1491,-1205,434,381,-868,870,-472,-75,496,-619,
				435,-77,-263,433,-380,165,92,-268,297,-185,-24,299,-673,-334,0,0,0,0,0,0,0,0,0,0
				,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				,0,0,0,0,0,0,0,0,0,0,0,0,0}, // rx_coef[128]
				64, // rx_coef_size
				{1280000000,320000000,160000000,80000000,40000000,40000000}, // rx_path_clks[6]
				33620685 // rx_bandwidth
};

AD9361_TXFIRConfig tx_fir_config = {
		3, // tx
		-6, // tx_gain
		1, // tx_int
		{-331,-646,271,-20,-172,277,-250,87,151,-352,402,-246,-70,403,-575,463,-73,-436,807,
				-809,359,398,-1117,1389,-931,-229,1685,-2711,2534,-531,-4134,20026,20026,-4134,
				-531,2534,-2711,1685,-229,-931,1389,-1117,398,359,-809,807,-436,-73,463,-575,403,-70,
				-246,402,-352,151,87,-250,277,-172,-20,271,-646,-331,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0}, // tx_coef[128]
				64, // tx_coef_size
				{1280000000,320000000,160000000,80000000,40000000,40000000}, // tx_path_clks[6]
				35301580 // tx_bandwidth
};

XGpioPs Gpio; /* The driver instance for GPIO Device. */
int XGpiops_Init(void)
{
	int Status;
	XGpioPs_Config *ConfigPtr;
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,
			ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	//SetDirection
	XGpioPs_SetDirectionPin(&Gpio,MIO_LED0,1);
	XGpioPs_SetDirectionPin(&Gpio,MIO_LED1,1);
	//Enable
	XGpioPs_SetOutputEnablePin(&Gpio,MIO_LED0,1);
	XGpioPs_SetOutputEnablePin(&Gpio,MIO_LED1,1);
	//Write
	XGpioPs_WritePin(&Gpio,MIO_LED0,0);
	XGpioPs_WritePin(&Gpio,MIO_LED1,0);

	return Status;
}

/**
 * ad936x GPIO EMIO Init
 *
 */
void ad936x_gpio_initial()
{
	//reset io
	default_init_param.gpio_resetb = EMIO_RESET;
	default_init_param.gpio_sync = -1;
	default_init_param.gpio_cal_sw1 = -1;
	default_init_param.gpio_cal_sw2 = -1;
	//di're
	gpio_direction(EMIO_TXNRX,1);
	gpio_direction(EMIO_ENABLE,1);
	gpio_direction(EMIO_RESET,1);
	gpio_direction(EMIO_SYNC,1);
	gpio_direction(EMIO_EN_AGC,1);
	gpio_direction(EMIO_CTL0,1);
	gpio_direction(EMIO_CTL1,1);
	gpio_direction(EMIO_CTL2,1);
	gpio_direction(EMIO_CTL3,1);

	gpio_set_value(EMIO_TXNRX,0);
	gpio_set_value(EMIO_ENABLE,0);
	gpio_set_value(EMIO_RESET,1);
	gpio_set_value(EMIO_SYNC,0);
	gpio_set_value(EMIO_EN_AGC,0);
	gpio_set_value(EMIO_CTL0,0);
	gpio_set_value(EMIO_CTL1,0);
	gpio_set_value(EMIO_CTL2,0);
	gpio_set_value(EMIO_CTL3,0);
}

/**
 * printf CatHead
 *
 */
void printf_logo(void){
	printf("\n");
	printf("\n");
	printf("\n");
	printf("                  1                10                \n");
	printf("                 01                100                \n");
	printf("                001                1000               \n");
	printf("               00001              000101              \n");
	printf("              001 001            1001  00             \n");
	printf("             001   10000000000001     100             \n");
	printf("          1000                        000             \n");
	printf("        1001                            0001          \n");
	printf("       001         0001         0001        100       \n");
	printf("      001          0001         0001          00      \n");
	printf("      00                    11                 00     \n");
	printf("      00                    00                 10     \n");
	printf("      100                 0000001              00     \n");
	printf("       100             010    0001          100       \n");
	printf("         100              00001            1001       \n");
	printf("           00000111                    10001          \n");
	printf("                 1110100000000000000111               \n");
	printf("  ______  ______  ______  _____   _____   _____   _____  \n");
	printf(" |  ____||  ____|/  ____||  __ \\ |  __ \\ |  __ \\ |  __ \\ \n");
	printf(" | |__   | |__   | (___  | |  | || |__) || |__) || |__) |\n");
	printf(" |  __|  |  __|   \\___ \\ | |  | ||  _  / |  _  / |  _  / \n");
	printf(" | |____ | |____  ____) || |__| || | \\ \\ | | \\ \\ | | \\ \\ \n");
	printf(" |______||______||_____/ |_____/ |_|  \\_\\|_|  \\_\\|_|  \\_\\\n");
	printf("\n");
}

/**
 * Set ad936x parameter
 *
 * Note:
 * @param	(TRmode=1) -> 2T2R
 * 			(TRmode=0) -> 1T1R
 * 			ad9361_phy->pdata->rx1tx1_mode_use_rx_num = 1; -> RX1
 * 			ad9361_phy->pdata->rx1tx1_mode_use_rx_num = 2; -> RX2
 * 			ad9361_phy->pdata->rx1tx1_mode_use_tx_num = 1; -> TX1
 * 			ad9361_phy->pdata->rx1tx1_mode_use_tx_num = 2; -> TX2
 */
int32_t ad936x_set_param(uint8_t TRmode){
	//Reset ad936x device...
	if (gpio_is_valid(default_init_param.gpio_resetb)) {
		gpio_set_value(default_init_param.gpio_resetb, 0);
		mdelay(1);
		gpio_set_value(default_init_param.gpio_resetb, 1);
		mdelay(1);
	}

	//Set TR_mode & TRX_Port
	if(TRmode){
		default_init_param.two_rx_two_tx_mode_enable = 1;
	}else{
		default_init_param.two_rx_two_tx_mode_enable = 0;
		default_init_param.one_rx_one_tx_mode_use_rx_num = 1;//RX port
		default_init_param.one_rx_one_tx_mode_use_tx_num = 1;//TX port
	}

	//ad936x_init
	status = ad9361_init(&ad9361_phy, &default_init_param);
	if (status < 0) {
		printf("ad936x Init Error: %ld\n", (long)status);
		return status;
	}

	//Set TX LO Freq
	status = ad9361_set_tx_lo_freq(ad9361_phy,TX_LO_Freq);
	if(status < 0 ){
		printf("ad936x Set TX_LO Error!\n");
		return status;
	}else {
		printf("ad936x Set TX_LO Successful!\n");
	}
	//Set RX LO Freq
	status = ad9361_set_rx_lo_freq(ad9361_phy,RX_LO_Freq);
	if(status < 0 ){
		printf("ad936x Set RX_LO Error!\n");
		return status;
	}else {
		printf("ad936x Set RX_LO Successful!\n");
	}
	// At 40 MS/s, OFDM uses bins +/-26 (16.25 MHz). The legacy FIR pair
	// attenuates bin 25 by 19 dB and bin 26 by 81 dB. RF bandwidth alone
	// does not change those coefficients. Bypass until suitable FIRs exist.
	status = ad9361_set_trx_fir_en_dis(ad9361_phy, 0);
	if(status < 0 ){
		printf("ad936x Bypass TRX FIR Error!\n");
		return status;
	}else {
		printf("ad936x Bypass TRX FIR Successful!\n");
	}
	//Set TX SamplingRate
	status = ad9361_set_tx_sampling_freq(ad9361_phy,TRX_SamplingRate);
	if(status < 0 ){
		printf("ad936x Set TX_SamplingRate Error!\n");
		return status;
	}else {
		printf("ad936x Set TX_SamplingRate Successful!\n");
	}
	//Set RX SamplingRate
	status = ad9361_set_rx_sampling_freq(ad9361_phy,TRX_SamplingRate);
	if(status < 0 ){
		printf("ad936x Set RX_SamplingRate Error!\n");
		return status;
	}else {
		printf("ad936x Set RX_SamplingRate Successful!\n");
	}
	//Set TX BandWidth
	status = ad9361_set_tx_rf_bandwidth(ad9361_phy,TX_BandWidth);
	if(status < 0 ){
		printf("ad936x Set TX_BandWidth Error!\n");
		return status;
	}else {
		printf("ad936x Set TX_BandWidth Successful!\n");
	}
	//Set RX BandWidth
	status = ad9361_set_rx_rf_bandwidth(ad9361_phy,RX_BandWidth);
	if(status < 0 ){
		printf("ad936x Set RX_BandWidth Error!\n");
		return status;
	}else {
		printf("ad936x Set RX_BandWidth Successful!\n");
	}
	//TX_ATT RX_GAIN RX_GAIN_MODE
	//Set CH1 TX_ATT RX_GAIN
	status = ad9361_set_tx_attenuation(ad9361_phy,0,TX_Att_CH1);
	if(status < 0 ){
		printf("ad936x Set CH1 TX_Att  Error!\n");
		return status;
	}else {
		printf("ad936x Set CH1 TX_Att  Successful!\n");
	}
	status = ad9361_set_rx_rf_gain(ad9361_phy, 0, RX_Gain_CH1);
	if(status < 0 ){
		printf("ad936x Set CH1 RX_Gain Error!\n");
		return status;
	}else {
		printf("ad936x Set CH1 RX_Gain Successful!\n");
	}
	status = ad9361_set_rx_gain_control_mode(ad9361_phy,0,RF_GAIN_MGC);
	if(status < 0 ){
		printf("ad936x Set CH1 RX_Gain Mode Error!\n");
		return status;
	}else {
		printf("ad936x Set CH1 RX_Gain Mode Successful!\n");
	}
	//Set CH2 TX_ATT RX_GAIN
	if(TRmode){
		status = ad9361_set_tx_attenuation(ad9361_phy, 1, TX_Att_CH2);
		if(status < 0 ){
			printf("ad936x Set CH2 TX_Att Error!\n");
			return status;
		}else {
			printf("ad936x Set CH2 TX_Att Successful!\n");
		}

		status = ad9361_set_rx_rf_gain(ad9361_phy, 1, RX_Gain_CH2);
		if(status < 0 ){
			printf("ad936x Set CH2 RX_Gain Error!\n");
			return status;
		}else {
			printf("ad936x Set CH2 RX_Gain Successful!\n");
		}
		status = ad9361_set_rx_gain_control_mode(ad9361_phy,1,RF_GAIN_SLOWATTACK_AGC);
		if(status < 0 ){
			printf("ad936x Set CH2 RX_Gain Mode Error!\n");
			return status;
		}else {
			printf("ad936x Set CH2 RX_Gain Mode Successful!\n");
		}
	}

	//ad936x data_clk & rx_data rx_fream Delay
	status = ad9361_spi_write(ad9361_phy->spi,REG_RX_CLOCK_DATA_DELAY,0x22);
	if (status < 0) {
		printf("ad936x Set clock/data delay Error!\n");
		return status;
	}

	//axi ps->pl
	Xil_Out32(axi_ad936x_TR_mode,TRmode);
	// DDS is removed from the new PL design; offset +4 remains reserved.
	//TR_mode = 2T2R -> f_clk = 4 * trx_Samplingrate
	//TR_mode = 1T1R -> f_clk = 2 * trx_Samplingrate
	printf("\n\r");
	return 0;
}

/**
 * Get ad936x parameter
 *
 * Note:
 * @param	(TRmode=1) -> 2T2R
 * 			(TRmode=0) -> 1T1R
 */
void ad936x_get_param(uint8_t TRmode){
	printf("Get ad936x Some Important Register...\n");

	ad936x_reg_value = ad9361_spi_read(ad9361_phy->spi, 0x002);
	bool tx1_en = (ad936x_reg_value & 0x40);
	bool tx2_en = (ad936x_reg_value & 0x80);
	ad936x_reg_value = ad9361_spi_read(ad9361_phy->spi, 0x003);
	bool rx1_en = (ad936x_reg_value & 0x40);
	bool rx2_en = (ad936x_reg_value & 0x80);
	if (tx1_en && tx2_en && rx1_en && rx2_en) {
		printf("ad936x TR_mode:2T2R\n");
	} else {
		printf("ad936x TR_mode:1T1R Port:TX%d & RX%d\n",tx1_en?1:2, rx1_en?1:2);
	}
	ad9361_get_tx_lo_freq(ad9361_phy,u64_value);
	printf("ad936x Get TX_LO_Freq       :%.2f MHz\n",(float)*u64_value/1e6);
	ad9361_get_rx_lo_freq(ad9361_phy,u64_value);
	printf("ad936x Get RX_LO_Freq       :%.2f MHz\n",(float)*u64_value/1e6);
	ad9361_get_tx_rf_bandwidth(ad9361_phy,u32_value);
	printf("ad936x Get TX_BandWidth     :%.2f KHz\n",(float)*u32_value/1e3);
	ad9361_get_rx_rf_bandwidth(ad9361_phy,u32_value);
	printf("ad936x Get RX_BandWidth     :%.2f KHz\n",(float)*u32_value/1e3);
	ad9361_get_tx_sampling_freq(ad9361_phy,u32_value);
	printf("ad936x Get TX_SamplingRate  :%.2f MSPS\n",(float)*u32_value/1e6);
	ad9361_get_rx_sampling_freq(ad9361_phy,u32_value);
	printf("ad936x Get RX_SamplingRate  :%.2f MSPS\n",(float)*u32_value/1e6);
	ad9361_get_rx_rf_gain(ad9361_phy,0,i32_value);
	printf("ad936x Get RX_CH1_Gain      :%ld dB\n",*i32_value);
	ad9361_get_rx_gain_control_mode(ad9361_phy,0,u8_value);
	printf("ad936x Get RX_CH1_Gain Mode :%d\n",*u8_value);
	if(TRmode){
		ad9361_get_rx_rf_gain(ad9361_phy,1,i32_value);
		printf("ad936x Get RX_CH2_Gain      :%ld dB\n",*i32_value);
		ad9361_get_rx_gain_control_mode(ad9361_phy,1,u8_value);
		printf("ad936x Get RX_CH2_Gain Mode :%d\n",*u8_value);
	}
}

void dot() { XGpioPs_WritePin(&Gpio, MIO_LED0, 1); usleep(150000); XGpioPs_WritePin(&Gpio, MIO_LED0, 0); usleep(150000); }
void dash() { XGpioPs_WritePin(&Gpio, MIO_LED1, 1); usleep(450000); XGpioPs_WritePin(&Gpio, MIO_LED1, 0); usleep(150000); }

static uint16_t packet_crc(const uint8_t *data, unsigned int size)
{
	uint16_t crc = 0xffff;
	unsigned int i;
	while (size--) {
		crc ^= (uint16_t)*data++ << 8;
		for (i = 0; i < 8; i++)
			crc = (crc & 0x8000) ? (crc << 1) ^ 0x1021 : crc << 1;
	}
	return crc;
}

static void uart_frame_send(uint8_t seq, uint8_t result, uint8_t flags,
		uint16_t length, const uint8_t *payload)
{
	uint8_t frame[73];
	uint16_t crc;
	unsigned int i;
	frame[0] = 0x5a; frame[1] = 0xa5; frame[2] = seq;
	frame[3] = result; frame[4] = flags;
	frame[5] = length; frame[6] = length >> 8;
	for (i = 0; i < 64; i++) frame[7 + i] = payload[i];
	crc = packet_crc(frame, 71);
	frame[71] = crc; frame[72] = crc >> 8;
	for (i = 0; i < sizeof(frame); i++) XUartPs_SendByte(UART_BASE, frame[i]);
}

static void uart_packet_loop(void)
{
	uint8_t frame[69], rx[64];
	unsigned int pos = 0, i, j = 0;
	uint32_t state, word;
	uint16_t crc, length;
	for (;;) {
		/* Search for sync; discard partial frames after a 100 ms inter-byte gap. */
		if (!XUartPs_IsReceiveData(UART_BASE)) {
			usleep(1000);
			if (pos && ++j >= 100) { pos = 0; j = 0; }
			continue;
		}
		j = 0;
		frame[pos] = XUartPs_RecvByte(UART_BASE);
		if (pos == 0 && frame[0] != 0xa5) continue;
		if (pos == 1 && frame[1] != 0x5a) {
			pos = frame[1] == 0xa5 ? 1 : 0;
			continue;
		}
		if (++pos != sizeof(frame)) continue;
		pos = 0;
		crc = packet_crc(frame, 67);
		if (frame[67] != (uint8_t)crc || frame[68] != (uint8_t)(crc >> 8)) {
			memset(rx, 0, sizeof(rx));
			uart_frame_send(frame[2], 2, 0, 0, rx);
			continue;
		}
		state = Xil_In32(MB_STATUS);
		if (state & 1) {
			memset(rx, 0, sizeof(rx));
			uart_frame_send(frame[2], 3, 0, 0, rx);
			continue;
		}
		for (i = 0; i < 16; i++) {
			word = (uint32_t)frame[3 + 4*i] | ((uint32_t)frame[4 + 4*i] << 8) |
				((uint32_t)frame[5 + 4*i] << 16) | ((uint32_t)frame[6 + 4*i] << 24);
			Xil_Out32(MB_TX + 4*i, word);
		}
		Xil_Out32(MB_CONTROL, 1);
		for (i = 0; i < 3000; i++) {
			state = Xil_In32(MB_STATUS);
			if (state & 2) break;
			usleep(100);
		}
		if (!(state & 2)) {
			memset(rx, 0, sizeof(rx));
			uart_frame_send(frame[2], 4, 0, 0, rx);
			continue;
		}
		length = (uint16_t)Xil_In32(MB_RX_LENGTH);
		for (i = 0; i < 16; i++) {
			word = Xil_In32(MB_RX + 4*i);
			for (j = 0; j < 4; j++) rx[4*i+j] = word >> (8*j);
		}
		uart_frame_send(frame[2], (state & 4) ? 0 : 1,
			(uint8_t)(state >> 2), length, rx);
	}
}

int main(void)
{
	int32_t init_status;

	Xil_ICacheEnable();
	Xil_DCacheEnable();
	init_status = uart_init();
	if (init_status != XST_SUCCESS)
		return init_status;
	printf_logo();
	usleep(50000);
	init_status = gpio_init(GPIO_DEVICE_ID);
	if (init_status != XST_SUCCESS || XGpiops_Init() != XST_SUCCESS)
		return XST_FAILURE;

	//ad936x init
	printf("\n\r");
	ad936x_gpio_initial();
	init_status = spi_init(ad936x_SPI_DEVICE_ID, 1, 0);
	if (init_status != XST_SUCCESS)
		return init_status;
	//ad936x Reset -> Init -> set tx rx param(trx_lo trx_fir trx_Samplingrate...)
	init_status = ad936x_set_param(ad936x_TRmode_1T1R);
	if (init_status < 0)
		return init_status;
	//ad936x get tx rx param(trx_lo trx_Samplingrate TX_Att RX_Gain...)
	ad936x_get_param(ad936x_TRmode_1T1R);

	//chip loop ad936xоƬ�ڲ��Իػ�
	//ad9361_spi_write(ad9361_phy->spi,REG_OBSERVE_CONFIG,0x01);

	dma_application_run();

	Xil_DCacheDisable();
	Xil_ICacheDisable();


	return 0;
}
