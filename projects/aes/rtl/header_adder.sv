// Add a constant header to the stream
// Header must be a larger multiple of the data width

module header_adder #(
	parameter int DATA_WIDTH 	= 128,
	parameter int HEADER_SIZE 	= 256
)(
	input clk,
	input rst_n,
	
	avalon_st_if.slave data_in,
	input logic [HEADER_SIZE-1:0] header_data,
	avalon_st_if.master data_out
);

logic [$clog2(HEADER_SIZE/DATA_WIDTH)] header_cntr;

enum int {
	IDLE_ST,
	HEADER_ST,
	DATA_ST 
} mod_st;

mod_st curr_st;

assign data_out.valid = data_in.valid;

always_comb begin : proc_async
	data_out.sop 	= (curr_st == IDLE_ST); // Sop always on, until state changes
	data_out.eop 	= (curr_st == DATA_ST & data_in.eop); // Eop when data eop
	data_out.data 	= (curr_st == DATA_ST) ? data_in.data : header_data[HEADER_SIZE-(DATA_WIDTH * header_cntr)-1:HEADER_SIZE-(DATA_WIDTH * (header_cntr+1))]
	data_out.empty  = (data_out.eop) ? data_in.empty : 'b0;
	data_in.ready 	= (curr_st == DATA_ST) & data_out.ready;
end

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		curr_st 		<= IDLE_ST;
		header_cntr 	<= 'b0;
	end else begin
		case (curr_st)
			IDLE_ST : begin
				if (data_in.valid) begin
					if (HEADER_SIZE == DATA_WIDTH) begin
						curr_st <= DATA_ST;
					end else begin
						curr_st <= HEADER_ST;
						header_cntr <= header_cntr + 1;
					end
				end
			end
			HEADER_ST : begin
				if (header_cntr < (HEADER_SIZE/DATA_WIDTH) - 1) begin
					header_cntr <= header_cntr + 1;
				end else begin
					curr_st <= DATA_ST;
				end
			end
			DATA_ST : begin
				if (data_in.eop & data_in.valid & data_in.ready) begin
					curr_st 	<= IDLE_ST;
					header_cntr <= 0;
				end
			default : data_in.ready <= 0; // Should not happen ever
		endcase
	end
end

endmodule