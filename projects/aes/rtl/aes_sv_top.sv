// Module acts as a replacement to the verilog top, to allow interfaces
// and easier control

import aes_top_pack::*;

module aes_sv_top (
	// General
	input logic clk,
	input logic rst_n,

	// Avalon MM
	input 	logic [ADDRESS_SIZE-1:0] 	mm_master_address,
	input 	logic 						mm_master_write,
	input 	logic [REG_SIZE-1:0] 		mm_master_writedata,
	input 	logic 						mm_master_read,
	output 	logic 						mm_master_readdatavalid,
	output 	logic [REG_SIZE-1:0] 		mm_master_readdata,
	output 	logic 						mm_master_waitrequest,

	// Recieve stream
	input 	logic [31:0] 				recieve_st_data,
	input 	logic 						recieve_st_valid,
	input	logic						recieve_st_sop,
	input 	logic 						recieve_st_eop,
	input 	logic [1:0] 				recieve_st_empty,
	output 	logic 						recieve_st_ready,

	// Transmit stream
	output 	logic [31:0] 				transmit_st_data,
	output 	logic 						transmit_st_valid,
	output 	logic 						transmit_st_sop,
	output 	logic 						transmit_st_eop,
	output 	logic [1:0] 				transmit_st_empty,
	input 	logic 						transmit_st_ready,

	// Called PLL_LOCKED
	output 	logic 						debug_led
);

	assign debug_led = 1'b0;

	logic 							header_valid;
	logic [IP_HEADER_WIDTH-1:0]		header_data;
	logic [REG_SIZE-1:0] 			header_first_word;
	logic [REG_SIZE-1:0] 			header_last_word;

	assign header_first_word 	= header_data[IP_HEADER_WIDTH-1:IP_HEADER_WIDTH-REG_SIZE];
	assign header_last_word 	= header_data[REG_SIZE-1:0];

	// Streams
	avalon_st_if recieve_st_msg(.clk(clk));
	avalon_st_if recieve_payload(.clk(clk));
	avalon_st_if transmit_payload(.clk(clk));
	avalon_st_if transmit_st_msg(.clk(clk));

	assign recieve_st_msg.data 	= recieve_st_data;
	assign recieve_st_msg.valid = recieve_st_valid;
	assign recieve_st_msg.sop 	= recieve_st_sop;
	assign recieve_st_msg.eop 	= recieve_st_eop;
	assign recieve_st_msg.empty = recieve_st_empty;
	assign recieve_st_ready 	= recieve_st_msg.ready;

	assign transmit_st_data 	= transmit_st_msg.data;
	assign transmit_st_valid 	= transmit_st_msg.valid;
	assign transmit_st_sop 		= transmit_st_msg.sop;
	assign transmit_st_eop 		= transmit_st_msg.eop;
	assign transmit_st_empty 	= transmit_st_msg.empty;
	assign transmit_st_msg.ready= transmit_st_ready;

register_controller main_register_controller (
	.clk                    (clk),
	.rst_n                  (rst_n),
	.mm_master_address      (mm_master_address),
	.mm_master_writedata    (mm_master_writedata),
	.mm_master_write        (mm_master_write),
	.mm_master_read         (mm_master_read),
	.mm_master_readdata     (mm_master_readdata),
	.mm_master_readdatavalid(mm_master_readdatavalid),
	.mm_master_waitrequest  (mm_master_waitrequest),
	.header_first_word      (header_first_word),
	.header_last_word       (header_last_word)
);

header_remover #(
	.DATA_WIDTH(MAC_STREAM_WIDTH),
	.HEADER_SIZE(IP_HEADER_WIDTH)
) ip_header_remover (
	.clk         (clk),
	.rst_n       (rst_n),
	.data_in     (recieve_st_msg),
	.header_data (header_data),
	.header_valid(header_valid),
	.data_out    (recieve_payload)
);

aes_ebc i_aes_ebc (.clk(clk), .rst_n(rst_n), .data_in(recieve_payload), .data_out(transmit_payload));

header_adder #(
	.DATA_WIDTH(MAC_STREAM_WIDTH),
	.HEADER_SIZE(IP_HEADER_WIDTH)
) ip_header_adder (
	.clk        (clk        ),
	.rst_n      (rst_n      ),
	.data_in    (transmit_payload),
	.header_data(header_data),
	.data_out   (transmit_st_msg)
);



endmodule