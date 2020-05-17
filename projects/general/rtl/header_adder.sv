// Add a constant header to the stream
// Header must be a larger multiple of the data width

module header_adder #(
	parameter int DATA_WIDTH 	= 128,
	parameter int HEADER_SIZE 	= 256
)(
	input logic clk,
	input logic rst_n,
	
	avalon_st_if.slave 				data_in,
 	input logic [HEADER_SIZE-1:0] 	header_data,
 	input logic 					header_vld,
 	avalon_st_if.master 			data_out
);

localparam int HEADER_WORD_COUNT = HEADER_SIZE/DATA_WIDTH;

logic [$clog2(HEADER_WORD_COUNT):0] header_cntr;

typedef enum {
	IDLE_ST,
	HEADER_ST,
	DATA_ST 
} mod_st;

mod_st curr_st;

// Header seperate to words
logic [DATA_WIDTH-1:0] header_sep [HEADER_WORD_COUNT-1:0];

genvar i;
generate
	for (i = 0; i < HEADER_WORD_COUNT; i++) begin : sep_gen
		// Seperates each word in the header
		assign header_sep[i] = header_data[HEADER_SIZE-(DATA_WIDTH * i)-1:HEADER_SIZE-(DATA_WIDTH * (i+1))];
	end
endgenerate

always_comb begin : proc_async
	data_out.sop 	= (curr_st == IDLE_ST); // Sop always on, until state changes
	data_out.eop 	= (curr_st == DATA_ST & data_in.eop); // Eop when data eop
	data_out.data 	= (curr_st == DATA_ST) ? data_in.data : header_sep[header_cntr]; // Takes a word from the header depending on the counter
	data_out.empty  = (data_out.eop) ? data_in.empty : 'b0; // Should be 0 unless given value at eop
	data_in.ready 	= (curr_st == DATA_ST) & data_out.ready; // Ready only when out is
	data_out.valid 	= (curr_st == DATA_ST) ? data_in.valid : ((curr_st == IDLE_ST) ? header_vld : 1'b1); // Valid when header is valid in idle or header state, else when data valid
end

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		curr_st 		<= IDLE_ST;
		header_cntr 	<= 'b0;
	end else begin
		case (curr_st)
			// Waiting for valid to send the header.
			IDLE_ST : begin
				if (data_out.valid & data_out.sop & data_out.ready) begin
					if (HEADER_WORD_COUNT == 1) begin
						curr_st <= DATA_ST;
					end
					else begin
						curr_st <= HEADER_ST;
					end
				end
			end
			// Sending rest of header
			HEADER_ST : begin
				if ((header_cntr < HEADER_WORD_COUNT - 1) & (data_out.valid & data_out.ready)) begin
					header_cntr <= header_cntr + 1;
				end else begin
					// Move to data
					curr_st <= DATA_ST;
				end
			end
			DATA_ST : begin
				if (data_in.eop & data_in.valid & data_in.ready) begin
					curr_st 	<= IDLE_ST;
					header_cntr <= 0;
				end
			end
			default : begin data_in.ready <= 0; end // Should not happen ever
		endcase
	end
end

endmodule