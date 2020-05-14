import aes_top_pack::*;

module register_controller (
	input logic clk,
	input logic rst_n,
	
	input 	logic [ADDRESS_SIZE-1:0] 		mm_master_address,
	input 	logic [REG_SIZE-1:0] 			mm_master_writedata,
	input 	logic							mm_master_write,
	input 	logic 							mm_master_read,
	output 	logic [REG_SIZE-1:0]			mm_master_readdata,
	output  logic 							mm_master_readdatavalid,
	output  logic 							mm_master_waitrequest,

	input 	logic [REG_SIZE-1:0] 			header_first_word,
	input 	logic [REG_SIZE-1:0] 			header_last_word
);


always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		mm_master_readdata 			<= 1'b0;
		mm_master_readdatavalid 	<= 1'b0;
		mm_master_waitrequest 		<= 1'b1;
	end else begin
		// Resets the value when unused
		mm_master_waitrequest 		<= 1'b0;
		mm_master_readdatavalid 	<= 1'b0;
		mm_master_readdata 			<= {REG_SIZE{1'b0}};

		/*
		// If write request
		if (mm_master_write) begin
			// Address switch case
			case (mm_master_address)
				// Asks for wait one clock
				default : mm_master_waitrequest <= 1'b1; // Should not happen
			endcase
		end
		*/
		// If read request
		if (mm_master_read) begin
			// Address switch case
			case (mm_master_address)
				FIRST_HEADER_ADDR	: 	mm_master_readdata <= header_first_word;
				LAST_HEADER_ADDR 	: 	mm_master_readdata <= header_last_word;
				default 			:  	mm_master_readdata <= {32{1'b1}};
			endcase
			// In every case of read, return valid so the system console wont get stuck.
			mm_master_readdatavalid <= 1'b1;
		end
	end
end

endmodule