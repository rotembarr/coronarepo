module register_controller (
	input logic clk,
	input logic rst_n,
	
	input 	logic [31:0] 	mm_address,
	input 	logic [31:0] 	mm_writedata,
	input 	logic			mm_write,
	input 	logic 			mm_read,
	output 	logic [31:0]	mm_readdata,
	output  logic 			mm_readdatavalid,
	output  logic 			mm_waitrequest,

	output  logic [7:0] 	msg_words_out,
	output 	logic 			msg_start,
	input   logic [7:0]		msg_words_in_remover,
	input 	logic [7:0] 	msg_words_in_adder
);

localparam int CONF_WORDS_ADDR 	= 'h0;
localparam int REMOVER_ADDR 	= 'h4;
localparam int ADDER_ADDR 		= 'h8;

always_ff @(posedge clk or negedge rst_n) begin : proc_sync
	if(~rst_n) begin
		msg_words_out <= 0;
		mm_readdata <= 0;
		mm_readdatavalid <= 0;
		mm_waitrequest <= 1;
		msg_start <= 0;
	end else begin
		mm_waitrequest <= 0;
		msg_start <= 0;
		if (mm_write) begin
			case (mm_address)
				CONF_WORDS_ADDR : begin 
					msg_words_out <= mm_writedata[7:0];
					msg_start <= 1;
				end
				default : mm_waitrequest <= 1;
			endcase
		end
		mm_readdatavalid <= 0;
		mm_readdata <= 0;
		if (mm_read) begin
			case (mm_address)
				CONF_WORDS_ADDR : 	mm_readdata <= {24'b0, msg_words_out};
				REMOVER_ADDR 	: 	mm_readdata <= {24'b0, msg_words_in_remover};
				ADDER_ADDR 		: 	mm_readdata <= {24'b0, msg_words_in_adder};
				default :  			mm_readdata <= {32{1'b1}};
			endcase
			mm_readdatavalid <= 1;
		end
	end
end

endmodule