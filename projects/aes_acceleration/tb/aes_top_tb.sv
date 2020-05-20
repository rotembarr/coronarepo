// As the true top module contains QSYS files, and its problematic
// to simulate them, this tb is to simulate the top without the
// AES module. This testbench should be updated manually

import aes_top_pack::*;

module aes_top_tb ();

	logic clk;
	logic rst_n;

	avalon_st_if #(.DATA_WIDTH(MAC_STREAM_WIDTH)) input_st();
	logic [MAC_HEADER_WIDTH-1:0] mac_data;
	logic mac_valid;
	avalon_st_if #(.DATA_WIDTH(MAC_STREAM_WIDTH)) removed_mac();
	avalon_st_if #(.DATA_WIDTH(MAC_STREAM_WIDTH)) controlled_msg();
	avalon_st_if #(.DATA_WIDTH(MAC_STREAM_WIDTH)) output_st();

	localparam logic [MAC_ADDR_WIDTH-1:0] fpga_mac = 'h001C24174ACB;

header_remover #(.DATA_WIDTH(MAC_STREAM_WIDTH), .HEADER_SIZE(MAC_HEADER_WIDTH)) i_header_remover (
	.clk         (clk         ),
	.rst_n       (rst_n       ),
	.data_in     (input_st),
	.header_data (mac_data ),
	.header_valid(mac_valid),
	.data_out    (removed_mac    )
);


	logic mac_drop;
	logic mac_drop_indication;
msg_dropper i_msg_dropper (
	.clk            (clk            ),
	.rst_n          (rst_n          ),
	.drop           (mac_drop           ),
	.msg_in         (removed_mac         ),
	.msg_out        (controlled_msg        ),
	.drop_indication(mac_drop_indication)
);

	logic msg_valid;

	assign mac_drop

header_adder #(.DATA_WIDTH(MAC_STREAM_WIDTH), .HEADER_SIZE(MAC_HEADER_WIDTH)) i_header_adder (
	.clk        (clk        ),
	.rst_n      (rst_n      ),
	.data_in    (controlled_msg    ),
	.header_data(header_data),
	.header_vld (header_vld ),
	.data_out   (data_out   )
);

endmodule