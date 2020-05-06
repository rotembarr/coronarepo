// Copyright (C) 2019  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

module led_blinker_top
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!

	// NET_PHY_MDC,
	// NET_PHY_MDIO,
	// NET_PHY_RESETn,
	// NET_SGMII_RX,
	// NET_SGMII_TX,
	PB_RESETn,
	PC_PHY_MDC,
	PC_PHY_MDIO,
	PC_PHY_RESETn,
	PC_SGMII_RX,
	PC_SGMII_TX,
	PLL_LOCKED,
	XCVR_REFCLK_125
// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!

);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
// output			NET_PHY_MDC;
// inout			NET_PHY_MDIO;
// output			NET_PHY_RESETn;
// input			NET_SGMII_RX;
// output			NET_SGMII_TX;
input			PB_RESETn;
output			PC_PHY_MDC;
inout			PC_PHY_MDIO;
output			PC_PHY_RESETn;
input			PC_SGMII_RX;
output			PC_SGMII_TX;
output			PLL_LOCKED;
input			XCVR_REFCLK_125;

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!

	// Qsys signals
	wire eth_mdio_mdio_in;
	wire eth_mdio_mdio_out;
	wire eth_mdio_mdio_oen;
	wire [31:0] eth_recieve_data;
	wire eth_recieve_endofpacket;
	wire [1:0] eth_recieve_empty;
	wire eth_recieve_ready;
	wire eth_recieve_startofpacket;
	wire eth_recieve_valid;
	wire [31:0] eth_transmit_data;
	wire eth_transmit_endofpacket;
	wire [1:0] eth_transmit_empty;
	wire eth_transmit_ready;
	wire eth_transmit_startofpacket;
	wire eth_transmit_valid;
	wire master_rst_reset;
	wire pll_clk_clk;
	wire [31:0] reg_mm_readdata;
	wire reg_mm_readdatavalid;
	wire [31:0] reg_mm_writedata;
	wire reg_mm_waitrequest;
	wire [31:0] reg_mm_address;
	wire reg_mm_write;
	wire reg_mm_read;

led_blinker i_led_blinker (
	.clk_clk                   (XCVR_REFCLK_125),
	.eth_mdio_mdc              (PC_PHY_MDC),
	.eth_mdio_mdio_in          (eth_mdio_mdio_in),
	.eth_mdio_mdio_out         (eth_mdio_mdio_out),
	.eth_mdio_mdio_oen         (eth_mdio_mdio_oen),
	.eth_recieve_data          (eth_recieve_data),
	.eth_recieve_endofpacket   (eth_recieve_endofpacket),
	.eth_recieve_error         (),
	.eth_recieve_empty         (eth_recieve_empty),
	.eth_recieve_ready         (eth_recieve_ready),
	.eth_recieve_startofpacket (eth_recieve_startofpacket),
	.eth_recieve_valid         (eth_recieve_valid),
	.eth_sgmii_rxp             (PC_SGMII_RX),
	.eth_sgmii_txp             (PC_SGMII_TX),
	.eth_transmit_data         (eth_transmit_data),
	.eth_transmit_endofpacket  (eth_transmit_endofpacket),
	.eth_transmit_error        (),
	.eth_transmit_empty        (eth_transmit_empty),
	.eth_transmit_ready        (eth_transmit_ready),
	.eth_transmit_startofpacket(eth_transmit_startofpacket),
	.eth_transmit_valid        (eth_transmit_valid),
	.fifo_in_data              (eth_recieve_data),
	.fifo_in_valid             (eth_recieve_valid),
	.fifo_in_ready             (eth_recieve_ready),
	.fifo_in_startofpacket     (eth_recieve_startofpacket),
	.fifo_in_endofpacket       (eth_recieve_endofpacket),
	.fifo_in_empty             (eth_recieve_empty),
	.fifo_out_data             (eth_transmit_data),
	.fifo_out_valid            (eth_transmit_valid),
	.fifo_out_ready            (eth_transmit_ready),
	.fifo_out_startofpacket    (eth_transmit_startofpacket),
	.fifo_out_endofpacket      (eth_transmit_endofpacket),
	.fifo_out_empty            (eth_transmit_empty),
	.master_rst_reset          (master_rst_reset),
	.pll_clk_clk               (pll_clk_clk),
	.ref_clk_clk               (XCVR_REFCLK_125),
	.reg_mm_waitrequest        (reg_mm_waitrequest),
	.reg_mm_readdata           (reg_mm_readdata),
	.reg_mm_readdatavalid      (reg_mm_readdatavalid),
	.reg_mm_burstcount         (),
	.reg_mm_writedata          (reg_mm_writedata),
	.reg_mm_address            (reg_mm_address),
	.reg_mm_write              (reg_mm_write),
	.reg_mm_read               (reg_mm_read),
	.reg_mm_byteenable         (),
	.reg_mm_debugaccess        (),
	.rst_reset_n               (PB_RESETn)
);

assign PC_PHY_MDIO 		= (eth_mdio_mdio_oen) ? 1'bz : eth_mdio_mdio_out;
assign eth_mdio_mdio_in = PC_PHY_MDIO;

assign PC_PHY_RESETn 	= PB_RESETn;

	wire msg_enter;

assign msg_enter = eth_recieve_ready & eth_recieve_endofpacket & eth_recieve_valid;

led_blinker_controller i_led_blinker_controller (
	.clk 					(pll_clk_clk),
	.rst 					(PB_RESETn),
	.master_mm_address      (reg_mm_address),
	.master_mm_readdata     (reg_mm_readdata),
	.master_mm_read         (reg_mm_read),
	.master_mm_write        (reg_mm_write),
	.master_mm_writedata    (reg_mm_writedata),
	.master_mm_readdatavalid(reg_mm_readdatavalid),
	.master_mm_waitrequest  (reg_mm_waitrequest),
	.master_rst             (master_rst_reset),
	.led_active             (PLL_LOCKED),
	.msg_enter 				(msg_enter)
);


// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
