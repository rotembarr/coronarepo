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
	.pll_0_outclk0_clk      (clk_clk      ),
	.pll_0_refclk_clk       (XCVR_REFCLK_125       ),
	.rst_reset_n            (PB_RESETn            )
);


	wire [7:0] msg_words_out;
	wire msg_start;
	wire [7:0] msg_words_in_remover;
	wire [7:0] msg_words_in_adder;
register_controller i_register_controller (
	.clk                 (clk_clk),
	.rst_n               (PB_RESETn               ),
	.mm_address          (mm_master_address          ),
	.mm_writedata        (mm_master_writedata        ),
	.mm_write            (mm_master_write            ),
	.mm_read             (mm_master_read             ),
	.mm_readdata         (mm_master_readdata         ),
	.mm_readdatavalid    (mm_master_readdatavalid    ),
	.mm_waitrequest      (mm_master_waitrequest      ),
	.msg_words_out       (msg_words_out       ),
	.msg_start           (msg_start           ),
	.msg_words_in_remover(msg_words_in_remover),
	.msg_words_in_adder  (msg_words_in_adder  )
);


	wire data_in_data;
	wire data_in_valid;
	wire data_in_ready;
	wire data_in_sop;
	wire data_in_eop;
	wire data_out_data;
	wire data_out_valid;
	wire data_out_ready;
	wire data_out_sop;
	wire data_out_eop;


header_adder i_header_adder (
	.clk           (clk_clk       ),
	.rst_n         (PB_RESETn     ),
	.header_data   (32'hffff0000),
	.data_in_valid (data_in_valid ),
	.data_in_sop   (data_in_sop   ),
	.data_in_eop   (data_in_eop   ),
	.data_in_empty (data_in_empty ),
	.data_in_ready (data_in_ready ),
	.data_out_valid(data_out_valid),
	.data_out_sop  (data_out_sop  ),
	.data_out_eop  (data_out_eop  ),
	.data_out_empty(data_out_empty),
	.data_out_ready(data_out_ready)
);


word_counter i_word_counter (
	.clk         (clk_clk           ),
	.rst_n       (PB_RESETn         ),
	.cntr        (msg_words_in_adder),
	.msg_in_valid(data_out_valid      ),
	.msg_in_sop  (data_out_sop    ),
	.msg_in_ready(data_out_ready      )
);


word_generator i_word_generator (
	.clk          (clk_clk      ),
	.rst_n        (PB_RESETn    ),
	.msg_word_cnt (msg_words_out),
	.msg_start    (msg_start    ),
	.msg_out_valid(data_in_valid),
	.msg_out_data (data_in_data ),
	.msg_out_sop  (data_in_sop  ),
	.msg_out_eop  (data_in_eop  ),
	.msg_out_empty(data_in_empty),
	.msg_out_ready(data_in_ready)
);


// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
