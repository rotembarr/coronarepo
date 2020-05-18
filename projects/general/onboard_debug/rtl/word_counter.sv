import aes_top_pack::*;

module word_counter (
	input logic clk,
	input logic rst_n,
	
	avalon_st_if.slave msg_in,

	output logic [WORD_COUNTER_SIZE-1:0] cntr
);

assign msg_in.ready = 1; // Always ready

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		cntr <= {WORD_COUNTER_SIZE{1'b0}};
	end else begin
		// Resets the counter
		if (msg_in.valid & msg_in.sop) begin
			cntr <= {{(WORD_COUNTER_SIZE-1){1'b0}}, 1'b1};
		// Increases the counter
		end else if (msg_in.valid) begin
			cntr <= cntr + 1'b1;
		end
	end
end

endmodule