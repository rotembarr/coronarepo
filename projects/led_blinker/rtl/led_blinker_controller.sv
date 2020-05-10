// Each address should be considered as {0x000004}XX

module led_blinker_controller (
	input logic clk,
	input logic rst,

	input 	logic [31:0] 	master_mm_address,
	output 	logic [31:0] 	master_mm_readdata,
	input 	logic 			master_mm_read,
	input 	logic 			master_mm_write,
	input 	logic [31:0] 	master_mm_writedata,
	output 	logic 			master_mm_readdatavalid,
	output 	logic 			master_mm_waitrequest,
	input 	logic 			master_rst,

	input	logic msg_enter,
	output 	logic led_active
);

logic [31:0] test_reg;

logic cntr_active;
logic [25:0] blink_counter;

logic [31:0] msg_counter;

always_ff @(posedge clk or negedge rst) begin : proc_sync
	if(~rst) begin
		led_active 				<= 1;
		master_mm_readdata 		<= 0;
		master_mm_readdatavalid <= 0;
		test_reg 				<= 0;
		master_mm_waitrequest 	<= 1;
		blink_counter 			<= 0;
		cntr_active 			<= 0;
	end else begin
		master_mm_waitrequest  	<= master_mm_write & ~master_mm_waitrequest;
		// Write by address
		if (master_mm_write) begin
			if (master_mm_address == 0) begin
				// Only one bit to activate counter
				cntr_active <= master_mm_writedata[0];
			end else if (master_mm_address == 4) begin
				// Test register, has no usage but to test writing and reading
				test_reg <= master_mm_writedata;
			end
		end

		// Increase counter if defined
		if (cntr_active) begin
			blink_counter <= blink_counter + 1;
		end else begin
			// If not active, resets the counter in order to prevent a case when counter stuck on only 1
			blink_counter <= 0;
		end

		// When counter reaches only 111..., de/activates the led
		if (blink_counter == {26{1'b1}}) begin
			led_active <= ~led_active;
		end

		// Increase msg counter
		if (msg_enter) begin
			msg_counter <= msg_counter + 1'b1;
		end

		// Reset the sent data and valid if no request
		master_mm_readdata 		<= 0;
		master_mm_readdatavalid <= 1'b0;
		// Read request
		if (master_mm_read) begin
			// Active led blinker
			if (master_mm_address == 0) begin
				master_mm_readdata 		<= {{31{1'b0}}, cntr_active};
				master_mm_readdatavalid <= 1'b1;
			// Test register
			end else if (master_mm_address == 4) begin
				master_mm_readdata 		<= test_reg;
				master_mm_readdatavalid <= 1'b1;
			// Msg counter
			end else if (master_mm_address == 8) begin
				master_mm_readdata 		<= msg_counter;
				master_mm_readdatavalid <= 1'b1;
			end
		end
	end
end

endmodule