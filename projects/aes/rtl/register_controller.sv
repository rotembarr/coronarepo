import aes_pack::*;

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

	output  logic [WORD_COUNTER_SIZE-1:0] 	msg_words_out,
	output 	logic 							msg_start,
	input   logic [WORD_COUNTER_SIZE-1:0]	msg_words_in_remover,
	input 	logic [WORD_COUNTER_SIZE-1:0] 	msg_words_in_adder
);


always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		msg_words_out 				<= 1'b0;
		mm_master_readdata 			<= 1'b0;
		mm_master_readdatavalid 	<= 1'b0;
		mm_master_waitrequest 		<= 1'b1;
		msg_start 					<= 1'b0;
	end else begin
		// Resets the value when unused
		mm_master_waitrequest 		<= 1'b0;
		msg_start 					<= 1'b0;
		mm_master_readdatavalid 	<= 1'b0;
		mm_master_readdata 			<= {REG_SIZE{1'b0}};

		// If write request
		if (mm_master_write) begin
			// Address switch case
			case (mm_master_address)
				MSG_WORD_CNT : begin // Signals the word generator to start working with the given size
					msg_words_out 	<= mm_master_writedata[WORD_COUNTER_SIZE-1:0];
					msg_start 		<= 1'b1;
				end
				// Asks for wait one clock
				default : mm_master_waitrequest <= 1'b1; // Should not happen
			endcase
		end
		// If read request
		if (mm_master_read) begin
			// Address switch case
			case (mm_master_address)
				MSG_WORD_CNT 		: 	mm_master_readdata <= {24'b0, msg_words_out};
				REMOVER_WORD_CNT 	: 	mm_master_readdata <= {24'b0, msg_words_in_remover};
				ADDER_WORD_CNT 		: 	mm_master_readdata <= {24'b0, msg_words_in_adder};
				default 			:  	mm_master_readdata <= {32{1'b1}};
			endcase
			// In every case of read, return valid so the system console wont get stuck.
			mm_master_readdatavalid <= 1'b1;
		end
	end
end

endmodule