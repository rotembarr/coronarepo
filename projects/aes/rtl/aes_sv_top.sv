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

	// Streams
	avalon_st_if recieve_st(.clk(clk));
	avalon_st_if removed_ether_st(.clk(clk));
	avalon_st_if msg_here(.clk(clk));
	avalon_st_if transmit_st(.clk(clk));

	// Stream assignments
	assign recieve_st.data 		= recieve_st_data;
	assign recieve_st.empty 	= recieve_st_empty;
	assign recieve_st.sop 		= recieve_st_sop;
	assign recieve_st.eop 		= recieve_st_eop;
	assign recieve_st.valid 	= recieve_st_valid;
	assign recieve_st_ready 	= recieve_st.ready;

	assign transmit_st_data 	= transmit_st.data;
	assign transmit_st_empty 	= transmit_st.empty;
	assign transmit_st_sop 	 	= transmit_st.sop;
	assign transmit_st_eop 		= transmit_st.eop;
	assign transmit_st_valid 	= transmit_st.valid;
	assign transmit_st.ready 	= transmit_st_ready;

	// Configs
	logic [MAC_ADDR_WIDTH-1:0] source_mac_addr;
	logic [MAC_ADDR_WIDTH-1:0] dest_mac_addr;
	logic addr_drop;

	// Modules output
	logic [MAC_ADDR_WIDTH*2-1:0] input_mac_addr;
	logic mac_addr_valid;
	logic wrong_addr;

register_controller i_register_controller (
	.clk(clk),
	.rst_n(rst_n),
	.mm_master_address(mm_master_address),
	.mm_master_writedata(mm_master_writedata),
	.mm_master_write(mm_master_write),
	.mm_master_read(mm_master_read),
	.mm_master_readdata(mm_master_readdata),
	.mm_master_readdatavalid(mm_master_readdatavalid),
	.mm_master_waitrequest(mm_master_waitrequest),
	.source_mac_addr(source_mac_addr),
	.dest_mac_addr(dest_mac_addr)
);

header_remover #(
	.DATA_WIDTH(MAC_STREAM_WIDTH),
	.HEADER_SIZE(MAC_ADDR_WIDTH*2)
) mac_header_remover (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(recieve_st),
	.header_data(input_mac_addr),
	.header_valid(mac_addr_valid),
	.data_out(removed_ether_st)
);

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		addr_drop <= 1'b0;
	end else begin
		// Checks if the message is for the FPGA
		if (mac_addr_valid) begin
			addr_drop <= input_mac_addr[MAC_ADDR_WIDTH*2-1:MAC_ADDR_WIDTH] != source_mac_addr;
		end
	end
end

assign debug_led = ~addr_drop;

msg_dropper addr_checker (
	.clk(clk),
	.rst_n(rst_n),
	.drop(addr_drop),
	.msg_in(removed_ether_st),
	.msg_out(msg_here),
	.drop_indication(wrong_addr)
);

header_adder #(
	.DATA_WIDTH(MAC_STREAM_WIDTH),
	.HEADER_SIZE(MAC_ADDR_WIDTH*2)
) mac_header_adder (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(msg_here),
	.header_data({dest_mac_addr, source_mac_addr}),
	.data_out(transmit_st)
);


endmodule