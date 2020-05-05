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
	// PC_PHY_MDC,
	// PC_PHY_MDIO,
	// PC_PHY_RESETn,
	// PC_SGMII_RX,
	// PC_SGMII_TX,
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
// output			PC_PHY_MDC;
// inout			PC_PHY_MDIO;
// output			PC_PHY_RESETn;
// input			PC_SGMII_RX;
// output			PC_SGMII_TX;
output			PLL_LOCKED;
input			XCVR_REFCLK_125;

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!


	led_blinker_controller i_led_blinker_controller (
		.clk                    (pll_0_outclk0_clk        ),
		.rst                    (PB_RESETn              ),
		.master_mm_address      (master_mm_address      ),
		.master_mm_readdata     (master_mm_readdata     ),
		.master_mm_read         (master_mm_read         ),
		.master_mm_write        (master_mm_write        ),
		.master_mm_writedata    (master_mm_writedata    ),
		.master_mm_readdatavalid(master_mm_readdatavalid),
		.master_rst             (master_rst_reset       ),
		.led_active             (PLL_LOCKED             ),
		.master_mm_waitrequest  (master_mm_waitrequest  )
	);

	wire [31:0] master_mm_address;
	wire [31:0] master_mm_readdata;
	wire master_mm_read;
	wire master_mm_write;
	wire [31:0] master_mm_writedata;
	wire master_mm_readdatavalid;
	wire master_rst_reset;
	wire master_mm_waitrequest;
	wire master_mm_byteenable;


	wire pll_0_outclk0_clk;
	wire pll_0_refclk_clk;

led_blinker i_led_blinker (
	.clk_clk                (pll_0_outclk0_clk),
	.master_mm_address      (master_mm_address      ),
	.master_mm_readdata     (master_mm_readdata     ),
	.master_mm_read         (master_mm_read         ),
	.master_mm_write        (master_mm_write        ),
	.master_mm_writedata    (master_mm_writedata    ),
	.master_mm_waitrequest  (master_mm_waitrequest  ),
	.master_mm_readdatavalid(master_mm_readdatavalid),
	.master_mm_byteenable   (master_mm_byteenable   ), // TODO: Check connection ! Signal/port not matching : Expecting logic [3:0]  -- Found logic 
	.master_rst_reset       (master_rst_reset       ),
	.pll_0_outclk0_clk      (pll_0_outclk0_clk      ),
	.pll_0_refclk_clk       (XCVR_REFCLK_125       ),
	.rst_reset_n            (PB_RESETn            )
);



// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
