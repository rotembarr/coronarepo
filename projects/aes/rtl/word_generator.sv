module word_generator (
	input logic clk,
	input logic rst_n,
	
	input logic [7:0] msg_word_cnt,
	input logic msg_start,
	output logic msg_out_valid,
	output logic [127:0] msg_out_data,
	output logic msg_out_sop,
	output logic msg_out_eop,
	output logic [6:0] msg_out_empty,
	input logic msg_out_ready
);

logic [7:0] curr_cntr;
logic cntr_act;

assign msg_out_empty 	= 0;
assign msg_out_valid 	= cntr_act;
assign msg_out_data 	= 0;

always_comb begin : proc_async
	msg_out_sop = (curr_cntr == 0);
	msg_out_eop = (curr_cntr == msg_word_cnt - 1) & cntr_act;
end

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		cntr_act <= 0;
		curr_cntr <= 0;
	end else begin
		if (msg_start) begin
			cntr_act <= 1;
		end
		if (msg_out_valid & msg_out_ready) begin
			if (msg_out_eop) begin
				curr_cntr <= 0;
				cntr_act <= 0;
			end else begin
				curr_cntr <= curr_cntr + 1;
			end
		end
	end
end

endmodule