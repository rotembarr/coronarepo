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
	//NET_SGMII_RX,
	//NET_PHY_MDIO,
	//NET_PHY_MDC,
	//PC_PHY_MDIO,
	//PC_PHY_MDC,
	//NET_SGMII_TX,
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
// input			NET_SGMII_RX;
// inout			NET_PHY_MDIO;
//output			NET_PHY_MDC;
//inout			PC_PHY_MDIO;
//output			PC_PHY_MDC;
//output			NET_SGMII_TX;
//output			PC_SGMII_TX;
input			PB_RESETn;
output			NET_PHY_RESETn;
output			PC_PHY_RESETn;

assign NET_PHY_RESETn = PB_RESETn;
assign PC_PHY_RESETn  = PB_RESETn;

// Connections from QSYS to top module
	wire clk_clk;
	wire [31:0] mm_master_address;
	wire [31:0] mm_master_readdata;
	wire mm_master_read;
	wire mm_master_write;
	wire [31:0] mm_master_writedata;
	wire mm_master_waitrequest;
	wire mm_master_readdatavalid;

jtag_to_mm i_jtag_to_mm (
	.clk_clk                (clk_clk                ),
	.mm_master_address      (mm_master_address      ),
	.mm_master_readdata     (mm_master_readdata     ),
	.mm_master_read         (mm_master_read         ),
	.mm_master_write        (mm_master_write        ),
	.mm_master_writedata    (mm_master_writedata    ),
	.mm_master_waitrequest  (mm_master_waitrequest  ),
	.mm_master_readdatavalid(mm_master_readdatavalid),
	.pll_0_outclk0_clk      (clk_clk      			),
	.pll_0_refclk_clk       (XCVR_REFCLK_125       	),
	.rst_reset_n            (PB_RESETn            	)
);

aes_sv_top i_aes_sv_top (
	.clk                    (clk_clk                ),
	.rst_n                  (PB_RESETn              ),
	.mm_master_address      (mm_master_address      ),
	.mm_master_write        (mm_master_write        ),
	.mm_master_writedata    (mm_master_writedata    ),
	.mm_master_read         (mm_master_read         ),
	.mm_master_readdatavalid(mm_master_readdatavalid),
	.mm_master_readdata     (mm_master_readdata     ),
	.mm_master_waitrequest  (mm_master_waitrequest  )
);

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
