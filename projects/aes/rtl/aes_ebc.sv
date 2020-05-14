module aes_ebc (
	input logic clk,
	input logic rst_n,
	
	avalon_st_if.slave 		data_in,
	avalon_st_if.master 	data_out
);

assign data_out.valid 	= data_in.valid;
assign data_out.sop   	= data_in.sop;
assign data_out.eop 	= data_in.eop;
assign data_out.empty 	= data_in.empty;

// Equals to all xor 1
genvar i;
generate
	for (i = 0; i < $bits(data_in.data); i++) begin : gen_not
		assign data_out.data[i] = ~data_in.data[i];
	end
endgenerate

endmodule