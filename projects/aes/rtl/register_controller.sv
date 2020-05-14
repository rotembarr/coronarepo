import aes_top_pack::*;

module register_controller (
	input logic clk,
	input logic rst_n,
	
	input 	logic [ADDRESS_SIZE-1:0] 		mm_master_address,
	input 	logic [REG_SIZE-1:0] 			mm_master_writedata,
	input 	logic							mm_master_write,
	input 	logic 							mm_master_read,
	output 	logic [REG_SIZE-1:0]			mm_master_readdata,
	output  logic 							mm_master_readdatavalid,
	output  logic 							mm_master_waitrequest,

	output 	logic [MAC_ADDR_WIDTH-1:0] 	source_mac_addr,
	output 	logic [MAC_ADDR_WIDTH-1:0] 	dest_mac_addr
);


always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		mm_master_readdata 			<= 1'b0;
		mm_master_readdatavalid 	<= 1'b0;
		mm_master_waitrequest 		<= 1'b1;
		source_mac_addr 			<= {MAC_ADDR_WIDTH{1'b0}};
		dest_mac_addr 				<= {MAC_ADDR_WIDTH{1'b0}};
	end else begin
		// Resets the value when unused
		mm_master_waitrequest 		<= 1'b0;
		mm_master_readdatavalid 	<= 1'b0;
		mm_master_readdata 			<= {REG_SIZE{1'b0}};

		// If write request
		if (mm_master_write) begin
			// Address switch case
			case (mm_master_address)
				SOURCE_MAC_ADDR_1 	: source_mac_addr[MAC_ADDR_WIDTH-1:MAC_ADDR_WIDTH-REG_SIZE] <= mm_master_writedata[MAC_ADDR_WIDTH-REG_SIZE-1:0];
				SOURCE_MAC_ADDR_2 	: source_mac_addr[REG_SIZE-1:0] 							<= mm_master_writedata;
				DEST_MAC_ADDR_1 	: dest_mac_addr[MAC_ADDR_WIDTH-1:MAC_ADDR_WIDTH-REG_SIZE] 	<= mm_master_writedata[MAC_ADDR_WIDTH-REG_SIZE-1:0];
				DEST_MAC_ADDR_2 	: dest_mac_addr[REG_SIZE-1:0] 								<= mm_master_writedata;
				// Asks for wait one clock
				default 			: mm_master_waitrequest <= 1'b1; // Non existent address
			endcase
		end
		
		// If read request
		if (mm_master_read) begin
			// Address switch case
			case (mm_master_address)
				SOURCE_MAC_ADDR_1 	: mm_master_readdata[MAC_ADDR_WIDTH-REG_SIZE-1:0] 	<= source_mac_addr[MAC_ADDR_WIDTH-1:MAC_ADDR_WIDTH-REG_SIZE];
				SOURCE_MAC_ADDR_2 	: mm_master_readdata 								<= source_mac_addr[REG_SIZE-1:0];
				DEST_MAC_ADDR_1 	: mm_master_readdata[MAC_ADDR_WIDTH-REG_SIZE-1:0]	<= source_mac_addr[MAC_ADDR_WIDTH-1:MAC_ADDR_WIDTH-REG_SIZE];
				DEST_MAC_ADDR_2	 	: mm_master_readdata 								<= source_mac_addr[REG_SIZE-1:0];
				default 			: mm_master_readdata 								<= {32{1'b1}};
			endcase
			// In every case of read, return valid so the system console wont get stuck.
			mm_master_readdatavalid <= 1'b1;
		end
	end
end

endmodule