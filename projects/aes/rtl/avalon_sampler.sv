// Non-generic, uses a 32 bit FIFO

module avalon_sampler (
	input clk,
	input rst_n,

	avalon_st_if.slave 	data_in,
	avalon_st_if.master data_out
	
);

single_word_fifo i_single_word_fifo (
	.clk_clk(clk),
	.msg_in_data(data_in.data),
	.msg_in_valid(data_in.valid),
	.msg_in_ready(data_in.ready),
	.msg_in_startofpacket(data_in.sop),
	.msg_in_endofpacket(data_in.eop),
	.msg_in_empty(data_in.empty),
	.msg_out_data(data_out.data),
	.msg_out_valid(data_out.valid),
	.msg_out_ready(data_out.ready),
	.msg_out_startofpacket(data_out.sop),
	.msg_out_endofpacket(data_out.eop),
	.msg_out_empty(data_out.empty),
	.reset_reset_n(rst_n)
);


endmodule