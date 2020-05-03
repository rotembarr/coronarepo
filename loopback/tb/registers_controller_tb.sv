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
		@(posedge clk);
		// Start debug reg
		reg_mm.address = 'h2;
		reg_mm.write = 1'b1;
		reg_mm.writedata = 'hdeadbeef;
		@(posedge clk);
		reg_mm.writedata = 'b0;
		reg_mm.write = 1'b0;
		@(posedge clk);
		reg_mm.read = 1'b1;
		@(posedge clk);
		reg_mm.read = 1'b0;
		// End debug reg
		// Start counter reg
		@(posedge clk);
		reg_mm.address = 'h0;
		reg_mm.read = 1'b1;
		@(posedge clk);
		reg_mm.read = 1'b0;
		msg_enter = 1;
		for (int i = 0; i < 10; i++) begin
			@(posedge clk); // Wait 10 clocks for the counter to raise
		end
		reg_mm.read = 1'b1;
		@(posedge clk);
		reg_mm.read = 1'b0;
		// End counter reg
		#1000ns;
		$finish();
	end

endmodule