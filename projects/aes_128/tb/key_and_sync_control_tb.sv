////////////////////////////////////////////////////////////////////////////////
//
// File name    : key_and_sync_control_tb.sv
// Date Created : 15

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Key and sync control testbench
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module key_and_sync_control_tb();

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	logic clk = 1'b0;
	logic rst = 1'b0;

	dvr_if #(2 * aes_model_pack::BLOCK_SIZE) key_and_sync_in(clk);

	logic 						key_and_sync_req = 1'b1;
	logic 						new_sync_req = 1'b0;
	logic 						key_and_sync_vld;
	logic 						sync_overlapse_irq;
	aes_model_pack::byte_table 	key;
	aes_model_pack::byte_table 	sync;

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	always
	begin
		#aes_model_pack::CLK_FREQ clk = ~clk;
	end

	initial begin
		key_and_sync_in.data <= {128'b1, 128'b1};
		key_and_sync_in.valid <= 1'b0;
		#20ns;
		@(posedge clk);
		rst <= 1'b1;
		$display("reset key %h", key);
		$display("reset sync %h", sync);
		// Value should be 0 after reset
		assert ((key == sync) & (key == 128'b0));

		#aes_model_pack::CLK_FREQ;	
		@(posedge clk);
		key_and_sync_in.valid <= 1'b1;

		#aes_model_pack::CLK_FREQ;	
		@(posedge clk);
		key_and_sync_in.valid <= 1'b0;
		key_and_sync_req <= 1'b0;

		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		// Value should be the one given at the start
		assert ((key == sync) & (key == 128'b1));
		new_sync_req <= 1'b1;

		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		new_sync_req <= 1'b0;

		repeat (2) begin
			#aes_model_pack::CLK_FREQ;
		end
		@(posedge clk);
		assert (sync == 128'b10);
		$display("second sync %h", sync);

		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_req <= 1'b1;
		key_and_sync_in.data <= {128'd102, 128'd412};
		key_and_sync_in.valid <= 1'b1;

		#aes_model_pack::CLK_FREQ;
		@(posedge clk);
		key_and_sync_req <= 1'b0;
		key_and_sync_in.valid <= 1'b0;

		repeat(2) begin
			#aes_model_pack::CLK_FREQ;
		end

		$finish();
	end

	///////////////////////////////////////////////////////////////////////////
	/////// Instantiations ////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	key_and_sync_control dut(
		.clk               (clk),
		.rst               (rst),
		.key_and_sync_in   (key_and_sync_in),
		.key_and_sync_req  (key_and_sync_req),
		.new_sync_req      (new_sync_req),
		.key_and_sync_vld  (key_and_sync_vld),
		.key               (key),
		.sync              (sync),
		.sync_overlapse_irq(sync_overlapse_irq)
	);

endmodule