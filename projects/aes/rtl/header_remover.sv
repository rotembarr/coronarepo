// Remove a constant header from the stream
// Header must be a larger multiple of the data width

module header_remover (
	parameter int DATA_WIDTH 	= 128,
	parameter int HEADER_SIZE 	= 256
)(
	input clk,
	input rst_n,
	
	avalon_st_if.slave data_in,
	output logic [HEADER_SIZE-1:0] header_data,
	output logic header_valid,
	avalon_st_if.master data_out
);

logic [$clog2(HEADER_SIZE/DATA_WIDTH):0] header_cntr;

typedef enum int {
	HEADER_ST,
	DATA_ST 
} mod_st;

mod_st curr_st;

logic data_start;

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		header_cntr <= 0;
		header_data <= 0;
		header_valid <= 0;
		curr_st <= HEADER_ST;
		data_start <= 1;
	end else begin
		case (curr_st)
			HEADER_ST : begin
				if (header_cntr == ((HEADER_SIZE/DATA_WIDTH)-1)) begin
					if (data_in.valid) begin
						curr_st <= DATA_ST;
					end
				end
			end
			default : data_in.ready = 0;
		endcase
	end
end

endmodule