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
	avalon_st_if transmit_st(.clk(clk));

	// Configs
	logic [MAC_ADDR_WIDTH-1:0] source_mac_addr;
	logic [MAC_ADDR_WIDTH-1:0] dest_mac_addr;


register_controller i_register_controller (
	.clk                    (clk                    ),
	.rst_n                  (rst_n                  ),
	.mm_master_address      (mm_master_address      ),
	.mm_master_writedata    (mm_master_writedata    ),
	.mm_master_write        (mm_master_write        ),
	.mm_master_read         (mm_master_read         ),
	.mm_master_readdata     (mm_master_readdata     ),
	.mm_master_readdatavalid(mm_master_readdatavalid),
	.mm_master_waitrequest  (mm_master_waitrequest  ),
	.source_mac_addr        (source_mac_addr        ),
	.dest_mac_addr          (dest_mac_addr          )
);


	avalon_st_if data_in();
	logic [MAC_ADDR_WIDTH*2-1:0] header_data;
	logic header_valid;
	avalon_st_if data_out();
header_remover #(.DATA_WIDTH(MAC_STREAM_WIDTH), .HEADER_SIZE(MAC_ADDR_WIDTH*2)) i_header_remover (
	.clk         (clk         ),
	.rst_n       (rst_n       ),
	.data_in     (data_in     ),
	.header_data (header_data ),
	.header_valid(header_valid),
	.data_out    (data_out    )
);


endmodule