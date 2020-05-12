module word_counter (
	input logic clk,
	input logic rst_n,
	
	input logic msg_in_valid,
	input logic msg_in_sop,
	output logic msg_in_ready,
	output logic [7:0] cntr
);

assign msg_in_ready = 1;

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		cntr <= 0;
	end else begin
		if (msg_in_valid & msg_in_sop) begin
			cntr <= 1;
		end else if (msg_in_valid) begin
			cntr <= cntr + 1;
		end
	end
end

endmodule