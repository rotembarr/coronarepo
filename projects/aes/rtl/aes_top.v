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

module aes_top
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!

	XCVR_REFCLK_125,
	PLL_LOCKED,
	//PC_SGMII_RX,
	NET_SGMII_RX,
	NET_PHY_MDIO,
	NET_PHY_MDC,
	//PC_PHY_MDIO,
	//PC_PHY_MDC,
	NET_SGMII_TX,
	//PC_SGMII_TX,
	PB_RESETn,
	NET_PHY_RESETn,
	PC_PHY_RESETn
// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!

);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
input			XCVR_REFCLK_125;
output			PLL_LOCKED;
// input			PC_SGMII_RX;
input			NET_SGMII_RX;
inout			NET_PHY_MDIO;
output			NET_PHY_MDC;
//inout			PC_PHY_MDIO;
//output			PC_PHY_MDC;
output			NET_SGMII_TX;
//output			PC_SGMII_TX;
input			PB_RESETn;
output			NET_PHY_RESETn;
output			PC_PHY_RESETn;

assign NET_PHY_RESETn = PB_RESETn;
assign PC_PHY_RESETn  = PB_RESETn;

// Connections from QSYS to top module
	wire eth_net_mac_mdio_mdio_in;
	wire eth_net_mac_mdio_mdio_out;
	wire eth_net_mac_mdio_mdio_oen;
	wire [31:0] eth_net_recieve_data;
	wire eth_net_recieve_endofpacket;
	wire [5:0] eth_net_recieve_error;
	wire [1:0] eth_net_recieve_empty;
	wire eth_net_recieve_ready;
	wire eth_net_recieve_startofpacket;
	wire eth_net_recieve_valid;
	wire [31:0] eth_net_transmit_data;
	wire eth_net_transmit_endofpacket;
	wire eth_net_transmit_error;
	wire [1:0] eth_net_transmit_empty;
	wire eth_net_transmit_ready;
	wire eth_net_transmit_startofpacket;
	wire eth_net_transmit_valid;
	wire master_rst_reset;
	wire mm_out_waitrequest;
	wire [31:0] mm_out_readdata;
	wire mm_out_readdatavalid;
	wire [31:0] mm_out_writedata;
	wire [9:0] mm_out_address;
	wire mm_out_write;
	wire mm_out_read;
	wire clk;


one_mac i_one_mac (
	.eth_net_conn_rxp              (NET_SGMII_RX                  ),
	.eth_net_conn_txp              (NET_SGMII_TX                  ),
	.eth_net_mac_mdio_mdc          (NET_PHY_MDC                   ),
	.eth_net_mac_mdio_mdio_in      (eth_net_mac_mdio_mdio_in      ),
	.eth_net_mac_mdio_mdio_out     (eth_net_mac_mdio_mdio_out     ),
	.eth_net_mac_mdio_mdio_oen     (eth_net_mac_mdio_mdio_oen     ),
	.eth_net_recieve_data          (eth_net_recieve_data          ),
	.eth_net_recieve_endofpacket   (eth_net_recieve_endofpacket   ),
	.eth_net_recieve_error         (eth_net_recieve_error         ),
	.eth_net_recieve_empty         (eth_net_recieve_empty         ),
	.eth_net_recieve_ready         (eth_net_recieve_ready         ),
	.eth_net_recieve_startofpacket (eth_net_recieve_startofpacket ),
	.eth_net_recieve_valid         (eth_net_recieve_valid         ),
	.eth_net_transmit_data         (eth_net_transmit_data         ),
	.eth_net_transmit_endofpacket  (eth_net_transmit_endofpacket  ),
	.eth_net_transmit_error        (eth_net_transmit_error        ),
	.eth_net_transmit_empty        (eth_net_transmit_empty        ),
	.eth_net_transmit_ready        (eth_net_transmit_ready        ),
	.eth_net_transmit_startofpacket(eth_net_transmit_startofpacket),
	.eth_net_transmit_valid        (eth_net_transmit_valid        ),
	.master_rst_reset              (master_rst_reset              ),
	.mm_out_waitrequest            (mm_out_waitrequest            ),
	.mm_out_readdata               (mm_out_readdata               ),
	.mm_out_readdatavalid          (mm_out_readdatavalid          ),
	.mm_out_burstcount             (                              ),
	.mm_out_writedata              (mm_out_writedata              ),
	.mm_out_address                (mm_out_address                ),
	.mm_out_write                  (mm_out_write                  ),
	.mm_out_read                   (mm_out_read                   ),
	.mm_out_byteenable             (                              ),
	.mm_out_debugaccess            (                              ),
	.reset_reset_n                 (PB_RESETn                     ),
	.out_pll_outclk0_clk           (clk                           ),
	.out_pll_refclk_clk            (XCVR_REFCLK_125               ),
	.clk_clk                       (XCVR_REFCLK_125)
);


	assign eth_net_mac_mdio_mdio_in = NET_PHY_MDIO;
	assign NET_PHY_MDIO = (eth_net_mac_mdio_mdio_oen == 1'b0) ? eth_net_mac_mdio_mdio_out : 1'bz;

aes_sv_top i_aes_sv_top (
	.clk                    (XCVR_REFCLK_125),
	.rst_n                  (PB_RESETn),
	.mm_master_address      (mm_out_address),
	.mm_master_write        (mm_out_write),
	.mm_master_writedata    (mm_out_writedata),
	.mm_master_read         (mm_out_read),
	.mm_master_readdatavalid(mm_out_readdatavalid),
	.mm_master_readdata     (mm_out_readdata),
	.mm_master_waitrequest  (mm_out_waitrequest),
	.debug_led              (PLL_LOCKED),
	.recieve_st_data        (eth_net_recieve_data),
	.recieve_st_valid       (eth_net_recieve_valid),
	.recieve_st_sop         (eth_net_recieve_startofpacket),
	.recieve_st_eop         (eth_net_recieve_endofpacket),
	.recieve_st_empty       (eth_net_recieve_empty),
	.recieve_st_ready       (eth_net_recieve_ready),
	.transmit_st_data       (eth_net_transmit_data),
	.transmit_st_valid      (eth_net_transmit_valid),
	.transmit_st_sop        (eth_net_transmit_startofpacket),
	.transmit_st_eop        (eth_net_transmit_endofpacket),
	.transmit_st_empty      (eth_net_transmit_empty),
	.transmit_st_ready      (eth_net_transmit_ready)
);

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
