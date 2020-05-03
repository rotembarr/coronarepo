///////////////////////////////////////////////
// This module's purpose is to allow future  //
// debug access using the registers. 		 //
///////////////////////////////////////////////

module registers_controller 
#(
	parameter int ADDR_BASE 	= 'h400, // As the addresses are decided by qsys, this parameter should be tested
	parameter int ADDR_STEP 	= 'h2,
	parameter int COUNTER_SIZE 	= 32,
	parameter int DATA_WIDTH	= 32,
	// Still unsure how much latency is expected
		// How long the read should be valid
		//parameter int RESPONSE_COUNTER_WIDTH = 3
)
(
	// General
	input logic clk,
	input logic rst_n,
	
	// Signals
	input logic msg_enter,

	// Avalon-mm
	avalon_mm_if.slave reg_mm
);

logic [COUNTER_SIZE-1:0] 	msg_cntr;
logic [DATA_WIDTH-1:0] 		debug_reg;

enum int {
	COUNTER = 0,
	DEBUG 	= 1
} addresses;

always_ff @(posedge clk or negedge rst_n) begin : proc_cntr_control
	if(~rst_n) begin
		msg_cntr 	<= 'b0;
		debug_reg 	<= 'b0;
	end else begin
		// Increase counter
		if (msg_enter) begin
			msg_cntr <= msg_cntr + 1'b1;
		end
		// The only writeable data currently
		if (reg_mm.write & (reg_mm.address == (ADDR_BASE + (ADDR_STEP * DEBUG)))) begin
			debug_reg <= reg_mm.writedata;
		end
		// When there is no read request, reset the output
		reg_mm.readdata 		<= 'b0;
		reg_mm.readdatavalid 	<= 1'b0;

		// If read request
		if (reg_mm.read) begin
			// If counter
			if (reg_mm.address == (ADDR_BASE + (ADDR_STEP * COUNTER))) begin
				reg_mm.readdata 		<= msg_cntr;
				reg_mm.readdatavalid 	<= 1'b1;
			end
			// If debug
			if (reg_mm.address == (ADDR_BASE + (ADDR_STEP * DEBUG))) begin
				reg_mm.readdata 		<= debug_reg;
				reg_mm.readdatavalid 	<= 1'b1;
			end
		end
	end
end

endmodule