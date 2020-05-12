// Add a constant header to the stream
// Header must be a larger multiple of the data width

module header_adder #(
	parameter int DATA_WIDTH 	= 128,
	parameter int HEADER_SIZE 	= 256
)(
	input logic clk,
	input logic rst_n,
	
	input logic [DATA_WIDTH-1:0] data_in_data,
	input logic data_in_valid,
	input logic data_in_sop,
	input logic data_in_eop,
	input logic [$clog2(DATA_WIDTH/8)-1:0] data_in_empty,
	output logic data_in_ready,
 	input logic [HEADER_SIZE-1:0] header_data,
	output logic data_out_valid,
	output logic data_out_sop,
	output logic data_out_eop,
	output logic [$clog2(DATA_WIDTH/8)-1:0] data_out_empty,
	input logic data_out_ready
);

logic [$clog2(HEADER_SIZE/DATA_WIDTH):0] header_cntr;

typedef enum int {
	IDLE_ST,
	HEADER_ST,
	DATA_ST 
} mod_st;

mod_st curr_st;

logic [DATA_WIDTH-1:0] header_sep [HEADER_SIZE/DATA_WIDTH-1:0];
genvar i;
generate
	for (i = 0; i < HEADER_SIZE/DATA_WIDTH; i++) begin : sep_gen
		assign header_sep[i] = header_data[HEADER_SIZE-(DATA_WIDTH * i)-1:HEADER_SIZE-(DATA_WIDTH * (i+1))];
	end
endgenerate

assign data_out_valid = data_in_valid;

always_comb begin : proc_async
	data_out_sop 	= (curr_st == IDLE_ST); // Sop always on, until state changes
	data_out_eop 	= (curr_st == DATA_ST & data_in_eop); // Eop when data eop
	data_out_data 	= (curr_st == DATA_ST) ? data_in_data : header_sep[header_cntr];
	data_out_empty  = (data_out_eop) ? data_in_empty : 'b0;
	data_in_ready 	= (curr_st == DATA_ST) & data_out_ready;
end

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		curr_st 		<= IDLE_ST;
		header_cntr 	<= 'b0;
	end else begin
		case (curr_st)
			IDLE_ST : begin
				if (data_in_valid) begin
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
				if (data_in_eop & data_in_valid & data_in_ready) begin
					curr_st 	<= IDLE_ST;
					header_cntr <= 0;
				end
			end
			default : begin data_in_ready <= 0; end // Should not happen ever
		endcase
	end
end

endmodule