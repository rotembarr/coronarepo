module registers_controller_tb ();

	localparam time CLK_FREQ 	= 5ns;
	localparam time RST_LEN 	= 20ns;

	logic clk;
	logic rst_n;
	logic msg_enter;
	avalon_mm_if reg_mm();

	registers_controller #(
		.ADDR_BASE(0)
	) dut (
		.clk(clk),
		.rst_n(rst_n),
		.msg_enter(msg_enter),
		.reg_mm(reg_mm)
	);

	initial begin
		clk = 1'b0;
		forever begin
			#CLK_FREQ clk = ~clk;
		end
	end

	initial begin
		// Reset process
		rst_n 		= 1'b0;
		msg_enter 	= 1'b0;
		reg_mm.ClearMaster();
		#RST_LEN;
		@(posedge clk);
		rst_n = 1'b1;
		#20000ns;
		$finish();
	end

endmodule