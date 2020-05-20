////////////////////////////////////////////////////////////////////////////////
//
// File name    : key_and_sync_control.sv
// Date Created : 15

//
////////////////////////////////////////////////////////////////////////////////
//
// Description: Module for controling the key and sync dvr.
//
////////////////////////////////////////////////////////////////////////////////
//
// Comments: 
//
////////////////////////////////////////////////////////////////////////////////

module key_and_sync_control
(
	// General
	input logic						  	clk,
	input logic 					  	rst,

	// Input stream
	dvr_if.slave				  		key_and_sync_in,

	// Inputs and outputs
	input logic 					  	key_and_sync_req,
	input logic 					  	new_sync_req,

	output aes_model_pack::byte_table 	key,
	output aes_model_pack::byte_table 	sync,
	output logic 					  	key_and_sync_vld,
	output logic 					  	sync_overlapse_irq
);
	///////////////////////////////////////////////////////////////////////////
	/////// Localparams ///////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	localparam int KEY_INDEX  = 0;
	localparam int SYNC_INDEX = aes_model_pack::BLOCK_SIZE;

	///////////////////////////////////////////////////////////////////////////
	/////// Declarations //////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Signal when to load the data, when valid and ready
	logic					   						key_and_sync_act;
	// Key register
	aes_model_pack::byte_table 				key_data;
	// Sync register
	aes_model_pack::byte_table 				sync_data;
	// Counter to see if a sync has reoccurred
	logic [aes_model_pack::BLOCK_SIZE-1:0]	sync_counter;

	///////////////////////////////////////////////////////////////////////////
	/////// Logic /////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

	// Take the key from the key start index
	assign key_data  = key_and_sync_in.data[SYNC_INDEX-1:KEY_INDEX];
	// Take the sync from the sync start index
	assign sync_data = aes_model_pack::byte_table'(key_and_sync_in.data[2*aes_model_pack::BLOCK_SIZE-1:SYNC_INDEX]);

	always_comb begin : proc_key_and_sync_act
		key_and_sync_act 	= key_and_sync_req & key_and_sync_in.valid;
		key_and_sync_in.rdy = key_and_sync_req;
	end

	// The key output depends on when the given data is valid and ready
	always_ff @(posedge clk or negedge rst) begin : proc_key
		if(~rst) begin
			key <= 0;
		end else begin

			// If the key is valid and ready, save the key data
			if(key_and_sync_act) begin
				key <= key_data;
			end
		end
	end

	// Sync output
	always_ff @(posedge clk or negedge rst) begin : proc_sync
		if(~rst) begin
			sync <= 0;
			key_and_sync_vld <= 1'b0;
		end else begin

			// If a new key and sync were given or a request for a new sync was given, changes the current sync according to the request
			if(new_sync_req | key_and_sync_act) begin
				sync <= (key_and_sync_act) ? sync_data : sync + 1;
			end

			key_and_sync_vld <= key_and_sync_act;
		end
	end
	

	// Counter for the irq
	always_ff @(posedge clk or negedge rst) begin : proc_sync_counter
		if(~rst) begin
			sync_counter 		<= 0;
			sync_overlapse_irq 	<= 1'b0;
		end else begin

			// If a new key and sync were given, resets the counter
			if(key_and_sync_act) begin
				sync_counter <= 0;

			// If a new sync request was given, raises the counter by one
			end else if(new_sync_req) begin
				sync_counter <= sync_counter + 1;
			end

			// If the counter has reached it's limit, it means that too the message was too long for a single key, and the sync will now start too overlapse,
			// which will cause for duplicate encryptions, and so it raises an irq to notify when this happens.
			if(sync_counter == 2 ** aes_model_pack::BLOCK_SIZE - 1) begin
				sync_overlapse_irq <= 1'b1;
			end
		end
	end

endmodule