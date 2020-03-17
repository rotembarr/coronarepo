module try1
(
	// Clock and Reset.	
	input logic 	clk,    												// Clock.
	input logic 	rst_n,  												// Asynchronous reset active low.

	// General.
	input logic		i, 												// Backpropagation needed in the current process.
	output logic	o 												// Backpropagation needed in the current process.
);

	always @(posedge clk or posedge rst_n) begin 
		if(!rst_n) begin
			o <= 0;
		end else begin
			o <= i;
		end
	end
endmodule