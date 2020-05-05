module led_blinker_controller (
	input logic clk,
	input logic rst,

	input 	logic [31:0] 	master_mm_address,
	output 	logic [31:0] 	master_mm_readdata,
	input 	logic 			master_mm_read,
	input 	logic 			master_mm_write,
	input 	logic [31:0] 	master_mm_writedata,
	output 	logic 			master_mm_readdatavalid,
	input 	logic 			master_rst,
	output 	logic 			master_mm_waitrequest,

	output logic led_active
);

logic [31:0] test_reg;

always_ff @(posedge clk or negedge rst) begin : proc_sync
	if(~rst) begin
		led_active 				<= 1;
		master_mm_readdata 		<= 0;
		master_mm_readdatavalid <= 0;
		test_reg 				<= 0;
		master_mm_waitrequest 	<= 1;
	end else begin
		master_mm_waitrequest  	<= master_mm_write & ~master_mm_waitrequest;
		if (master_mm_write) begin
			if (master_mm_address == 0) begin
				led_active <= master_mm_writedata[0];
			end else if (master_mm_address == 1) begin
				test_reg <= master_mm_writedata;
			end
		end
		master_mm_readdata 		<= 0;
		master_mm_readdatavalid <= 1'b1;
		if (master_mm_read) begin
			if (master_mm_address == 0) begin
				master_mm_readdata 		<= {{31{1'b0}}, led_active};
				master_mm_readdatavalid <= 1'b1;
			end else if (master_mm_address == 1) begin
				master_mm_readdata 		<= test_reg;
				master_mm_readdatavalid <= 1'b1;
			end
		end
	end
end

endmodule