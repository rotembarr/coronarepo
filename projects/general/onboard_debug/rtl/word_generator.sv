module word_generator #(
	parameter int DATA_WIDTH 		= 128,
	parameter int WORD_COUNTER_SIZE = 8
)(
	input logic clk,
	input logic rst_n,
	
	avalon_st_if.master 					msg_out,

	input 	logic [WORD_COUNTER_SIZE-1:0] 	msg_word_cnt,
	input 	logic 							msg_start
);

logic [WORD_COUNTER_SIZE-1:0] 	curr_cntr; // Word counter
logic 							cntr_act;  // Counter active

assign msg_out.empty 	= {$bits(msg_out.empty){1'b0}}; // Empty always 0
assign msg_out.valid 	= cntr_act; 					// Valid is when creating message
assign msg_out.data 	= {DATA_WIDTH{1'b0}};			// Data always 0

always_comb begin : proc_async
	msg_out.sop = (curr_cntr == {WORD_COUNTER_SIZE{1'b0}});			// SOP when counter starts
	msg_out.eop = (curr_cntr == msg_word_cnt - 1'b1) & cntr_act; 	// EOP when counter ends
end

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		cntr_act 	<= 1'b0;
		curr_cntr 	<= {WORD_COUNTER_SIZE{1'b0}};
	end else begin
		// Signals the generator to start
		if (msg_start) begin
			cntr_act <= 1'b1;
		end
		// Advances or stops the counter
		if (msg_out.valid & msg_out.ready) begin
			if (msg_out.eop) begin
				curr_cntr 	<= {WORD_COUNTER_SIZE{1'b0}};
				cntr_act 	<= 1'b0;
			end else begin
				curr_cntr 	<= curr_cntr + 1'b1;
			end
		end
	end
end

endmodule