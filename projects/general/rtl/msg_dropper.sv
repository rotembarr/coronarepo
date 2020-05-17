module msg_dropper (
	input logic clk,
	input logic rst_n,
	
	input logic drop,

	avalon_st_if.slave 	msg_in,
	avalon_st_if.master msg_out,

	output logic drop_indication
);

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		drop_indication <= 1'b0;
	end else begin
		// Keeps drop signal when message starts
		if (msg_in.valid & msg_in.ready & msg_in.sop) begin
			drop_indication <= drop;
		end
		// Clears drop signal when message ends
		if (msg_in.valid & msg_in.ready & msg_in.eop) begin
			drop_indication <= 1'b0;
		end
	end
end

// Untouched data
assign msg_out.data 	= msg_in.data;
assign msg_out.empty 	= msg_in.empty;
assign msg_out.sop 		= msg_in.sop;
assign msg_out.eop 		= msg_out.eop;
assign msg_in.ready 	= msg_out.ready;

// Valid only when not dropping
always_comb begin : proc_async
	msg_out.valid = msg_in.valid & ((msg_in.sop) ? drop : drop_indication);
end

endmodule