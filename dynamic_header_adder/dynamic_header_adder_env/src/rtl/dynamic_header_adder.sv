/***************************************************************************
- dynamic header adder -
This module recieves an header (dynamic size) and then a msg (dynamic size).
It concatenates it to one msg.
Both the msg and the header is avalon st and the same bus width.
***************************************************************************/

module dynamic_header_adder # 
( 
	parameter DATA_WIDTH_IN_BYTES = 4
)
(
	input logic clk,
	input logic rst,

	avalon_st_if.slave  	msg_in_st,
	avalon_st_if.slave  	header_in_st,
	avalon_st_if.master  	msg_out_st
);

	typedef enum int unsigned
	{
		HEADER_RECIEVING,			// recieve the header and send it, except for the last word if there are empty bytes
		MSG_RECIEVING,				// recieve the msg and send it, with the last header word
		SEND_LAST_ADDITIONAL_WORD	// send eop if the sum of the last header word and the last msg word is bigger than one word
	} state_t;

	state_t state;

	logic [DATA_WIDTH_IN_BYTES * $bits(byte) - 1 : 0] 	data_reg;
	logic [$bits(msg_in_st.empty) - 1 : 0]				offset;
	logic [$bits(msg_in_st.empty) - 1 : 0]				async_offset;
	logic [DATA_WIDTH_IN_BYTES * $bits(byte) - 1 : 0] 	mask;
	logic [$bits(msg_in_st.empty) - 1 : 0]				last_empty;

	always_ff @(posedge clk or negedge rst) begin : sync_proc
		if(~rst) begin
			data_reg	<= {$bits(data_reg){1'b0}};
			offset		<= {$bits(offset){1'b0}};
			mask		<= {$bits(mask){1'b0}};
			last_empty	<= {$bits(last_empty){1'b0}};
			state 		<= HEADER_RECIEVING;

		end else begin
			case (state)
				HEADER_RECIEVING: begin
					data_reg 	<= header_in_st.data;
					// offset is equal to the existing bytes at the last word (if there are empty bytes)
					offset		<= header_in_st.empty ? (DATA_WIDTH_IN_BYTES - header_in_st.empty) : {$bits(offset){1'b0}};
					// "turn on" the empty bytes of the last header word
					mask		<= {DATA_WIDTH_IN_BYTES * $bits(byte){1'b1}} >> (async_offset * $bits(byte));

					if (header_in_st.eop & header_in_st.valid & msg_out_st.rdy) begin
						state 	<= MSG_RECIEVING;
					end
				end

				MSG_RECIEVING: begin
					if (msg_in_st.valid & msg_out_st.rdy) begin
						// shifting the reg to contain the unsent part of bytes
						data_reg <= msg_in_st.data << ((DATA_WIDTH_IN_BYTES - offset) * $bits(byte));
					end
					last_empty 	<= DATA_WIDTH_IN_BYTES - offset + msg_in_st.empty;

					if (msg_in_st.eop & (msg_in_st.empty >= offset) & msg_in_st.valid & msg_out_st.rdy) begin
						state	<= HEADER_RECIEVING;
					end
					else if (msg_in_st.eop & (msg_in_st.empty < offset) & msg_in_st.valid & msg_out_st.rdy) begin
						state	<= SEND_LAST_ADDITIONAL_WORD;
					end
				end

				SEND_LAST_ADDITIONAL_WORD: begin
					if (msg_out_st.rdy) begin
						state 	<= HEADER_RECIEVING;
					end
				end
			endcase
		end
	end

	always_comb begin : async_proc
		case (state)
			HEADER_RECIEVING: begin
				// send valid when header is valid except for the last word (if there are empty bytes)
				msg_out_st.valid 	= header_in_st.valid & (~header_in_st.eop | header_in_st.empty == {$bits(header_in_st.empty){1'b0}});
				msg_out_st.data		= header_in_st.data;
				msg_out_st.sop		= header_in_st.sop;
				msg_out_st.eop		= 1'b0;
				msg_out_st.empty	= {$bits(msg_out_st.empty){1'b0}};

				header_in_st.rdy	= msg_out_st.rdy;
				msg_in_st.rdy		= 1'b0;
			end

			MSG_RECIEVING: begin
				msg_out_st.valid	= msg_in_st.valid;
				// concatenate the last part of the privious word with the first part of the current word
				msg_out_st.data		= (data_reg & ~mask) | ((msg_in_st.data >> (offset * $bits(byte))) & mask);
				msg_out_st.sop		= 1'b0;
				// send eop when eop msg sent, unless additional word is needed to be sent
				msg_out_st.eop		= msg_in_st.eop & (msg_in_st.empty >= offset);
				msg_out_st.empty	= (msg_in_st.empty > offset) ? (msg_in_st.empty - offset) : {$bits(msg_out_st.empty){1'b0}};

				header_in_st.rdy	= 1'b0;
				msg_in_st.rdy 		= msg_out_st.rdy;
			end

			SEND_LAST_ADDITIONAL_WORD: begin
				msg_out_st.valid 	= 1'b1;
				msg_out_st.data		= data_reg;
				msg_out_st.sop		= 1'b0;
				msg_out_st.eop		= 1'b1;
				msg_out_st.empty	= last_empty;

				header_in_st.rdy	= 1'b0;
				msg_in_st.rdy		= 1'b0;
			end
		endcase
	end

	assign async_offset = header_in_st.empty ? (DATA_WIDTH_IN_BYTES - header_in_st.empty) : {$bits(offset){1'b0}};


endmodule