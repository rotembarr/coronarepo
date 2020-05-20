// DVR - data valid ready

interface dvr_if #(parameter int DATA_WIDTH = 128) (input logic clk);

logic [DATA_WIDTH-1:0] data;
logic valid;
logic ready;

modport slave (
	input data,
	input valid,
	output ready
);

modport master (
	output data,
	output valid,
	input ready
);

task ClearSlave();
	ready = 0;
endtask : ClearSlave

task ClearMaster();
	data 	= 0;
	valid 	= 0;
endtask : ClearMaster

endinterface