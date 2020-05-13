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
	output 	logic 						mm_master_waitrequest
);
	
	// Const header to test
	localparam logic [255:0] CONST_HEADER = 256'hf0e1d2c3b4a5968778695a4b3c2d1e0faaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;

	// Counters and controls
	logic [WORD_COUNTER_SIZE-1:0] 	msg_words_out;
	logic 							msg_start;
	logic [WORD_COUNTER_SIZE-1:0] 	msg_words_in_remover;
	logic [WORD_COUNTER_SIZE-1:0] 	msg_words_in_adder;
	
	// Streams
	avalon_st_if header_adder_msg(.clk(clk));
	avalon_st_if added_header_msg(.clk(clk));

register_controller main_register_controller (
	.clk                    (clk),
	.rst_n                  (rst_n),
	.msg_words_out          (msg_words_out),
	.msg_start              (msg_start),
	.msg_words_in_remover   (msg_words_in_remover),
	.msg_words_in_adder     (msg_words_in_adder),
	.mm_master_address      (mm_master_address),
	.mm_master_writedata    (mm_master_writedata),
	.mm_master_write        (mm_master_write),
	.mm_master_read         (mm_master_read),
	.mm_master_readdata     (mm_master_readdata),
	.mm_master_readdatavalid(mm_master_readdatavalid),
	.mm_master_waitrequest  (mm_master_waitrequest)
);

word_generator header_adder_stream (
	.clk         (clk),
	.rst_n       (rst_n),
	.msg_out     (header_adder_stream),
	.msg_word_cnt(msg_words_out),
	.msg_start   (msg_start)
);

header_adder const_header_adder (
	.clk        (clk),
	.rst_n      (rst_n),
	.data_in    (header_adder_msg),
	.header_data(CONST_HEADER),
	.data_out   (added_header_msg)
);

word_counter adder_counter (
	.clk(clk),
	.rst_n(rst_n),
	.msg_in(msg_in),
	.cntr(msg_words_in_adder)
);


endmodule