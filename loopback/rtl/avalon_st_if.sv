// Simple avalon st interface, to be moved to general

interface avalon_st_if #(parameter DATA_WIDTH = 32) (input logic clk);
	logic vld, rdy;
	logic sop, eop;
	logic [DATA_WIDTH-1:0] data;
	logic [$clog2(DATA_WIDTH)-1:0] empty;

	modport master (
		output 	vld,
		input 	rdy,
		output 	sop,
		output 	eop,
		output 	data,
		output 	empty
	);

	modport slave (
		input 	vld,
		output 	rdy,
		input 	sop,
		input 	eop,
		input 	data,
		input 	empty
	);	

	task ClearMaster();
		vld 	= 1'b0;
		sop 	= 1'b0;
		eop 	= 1'b0;
		data 	= 'b0;
		empty 	= 'b0;
	endtask : ClearMaster

	task ClearSlave();
		rdy 	= 1'b0;
	endtask : ClearSlave

endinterface