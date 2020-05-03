// Simple avalon mm interface, to be moved to general

interface avalon_mm_if #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (logic clk);
	logic [ADDR_WIDTH-1:0] address;
	logic read, write;
	logic [DATA_WIDTH-1:0] writedata, readdata;
	logic readdatavalid;

	modport slave (
		input 	address,
		input 	read,
		input 	write,
		input 	writedata,
		output 	readdata,
		output 	readdatavalid
	);

	modport master (
		output 	address,
		output 	read,
		output 	write,
		output 	writedata,
		input 	readdata,
		input 	readdatavalid
	);

	task ClearSlave();
		readdata 		= 'b0;
		readdatavalid 	= 'b0;
	endtask : ClearSlave

	task ClearMaster();
		address 	= 'b0;
		read 		= 1'b0;
		write 		= 1'b0;
		writedata 	= 'b0;		
	endtask : ClearMaster

endinterface