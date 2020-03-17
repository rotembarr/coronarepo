module try1_tb ();

	logic 	clk;
	logic 	rst_n;
	logic	i;
	logic	o;
	
	initial begin 
		clk = 1'b0;
		rst_n = 1'b0;
		i = 1'b0;

		repeat (10) begin
			@(posedge clk);
			#0;
		end	 
		rst_n = 1'b1;

		repeat (50) begin 
			@(posedge clk);
			#0;
		end
		i = std::randomize();
	

		repeat (50) begin 
			@(posedge clk);
			#0;
		end
		i = ~i;
	end

	always begin 
		# 5ns;
		clk = ~clk;
	end

	try1
	try1_inst
	(
		.clk(clk),
		.rst_n(rst_n),
		.i(i),
		.o(o)
	);

endmodule