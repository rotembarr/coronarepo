module loopback_top (
	input logic clk,
	input logic rst_n,
	// Unknown inputs and outputs
);

	// Assign msg_enter = mac_recieve sop & vld & rdy

	logic msg_enter;
	avalon_mm_if reg_mm();

	registers_controller i_registers_controller
	(
		.clk(clk), 
		.rst_n(rst_n), 
		.msg_enter(msg_enter), 
		.reg_mm(reg_mm)
	);


endmodule