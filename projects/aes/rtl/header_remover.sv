// Remove a constant header from the stream
// Header must be a larger multiple of the data width

module header_remover #(
	parameter int DATA_WIDTH 	= 128,
	parameter int HEADER_SIZE 	= 256
)(
	input logic clk,
	input logic rst_n,
	
	avalon_st_if.slave data_in,
	output logic [HEADER_SIZE-1:0] header_data,
	output logic header_valid,
	avalon_st_if.master data_out
);

localparam int HEADER_WORDS = HEADER_SIZE/DATA_WIDTH;

logic [$clog2(HEADER_WORDS):0] header_cntr;

typedef enum int {
	HEADER_ST,
	DATA_ST 
} mod_st;

mod_st curr_st;

// Unchanged data
assign data_out.data 	= data_in.data;
assign data_out.eop  	= data_in.eop;
assign data_out.empty 	= data_in.empty;

always_comb begin : proc_async
	data_in.ready 	= (curr_st == HEADER_ST) | data_out.ready;
	data_out.valid 	= (curr_st == DATA_ST) & data_in.valid;
end

genvar i;

generate
	for (i = 0; i < HEADER_WORDS; i++) begin : header_data_gen
		always_ff @(posedge clk or negedge rst_n) begin : proc_gen_sync
			if(~rst_n) begin
				header_data[HEADER_SIZE-(DATA_WIDTH * i)-1:HEADER_SIZE-(DATA_WIDTH * (i+1))] <= {DATA_WIDTH{1'b0}};
			end else begin
				if ((header_cntr == i) & data_in.ready & data_in.valid & (curr_st == HEADER_ST)) begin
					header_data[HEADER_SIZE-(DATA_WIDTH * i)-1:HEADER_SIZE-(DATA_WIDTH * (i+1))] <= data_in.data;
				end
			end
		end
	end
endgenerate

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		header_cntr 	<= {$bits(header_cntr){1'b0}};
		header_valid 	<= 1'b0;
		curr_st 		<= HEADER_ST;
	end else begin
		// Control header word counter
		if ((curr_st == HEADER_ST) & data_in.valid)  begin
			header_cntr <= header_cntr + 1'b1;
		end
		// Resets the sop
		if (data_out.sop & (curr_st == DATA_ST) & data_out.valid & data_out.ready) begin
			data_out.sop <= 1'b0;
		end
		// State machine control
		case (curr_st)
			HEADER_ST : begin
				if ((header_cntr == (HEADER_WORDS-1)) & data_in.valid & data_in.ready) begin
					curr_st 		<= DATA_ST;
					data_out.sop 	<= 1'b1;
					header_valid 	<= 1'b1;
				end
			end
			DATA_ST : begin
				if (data_in.valid & data_in.ready & data_in.eop) begin
					curr_st 		<= HEADER_ST;
					header_valid 	<= 1'b0;
				end
			end
			default : data_in.ready <= 0;
		endcase
	end
end

endmodule