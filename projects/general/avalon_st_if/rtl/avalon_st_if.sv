interface avalon_st_if #(parameter int DATA_WIDTH = 128) (input logic clk);

logic [DATA_WIDTH-1:0] data;
logic valid;
logic ready;
logic [$clog2(DATA_WIDTH/$bits(byte))-1:0] empty;
logic sop;
logic eop;

modport slave (
	input data,
	input valid,
	output ready,
	input empty,
	input sop,
	input eop
);

modport master (
	output data,
	output valid,
	input ready,
	output empty,
	output sop,
	output eop
);

task ClearSlave();
	ready = 0;
endtask : ClearSlave

task ClearMaster();
	data 	= 0;
	valid 	= 0;
	empty 	= 0;
	sop 	= 0;
	eop 	= 0;
endtask : ClearMaster

endinterface