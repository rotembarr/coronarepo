`include "uvm_macros.svh"
`include "uvm_pkg.sv"
import uvm_pkg::*;

class my_test extends uvm_test;
	`uvm_component_utils(my_test)

	function new (string name = "my_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual task run_phase (uvm_phase phase);
		`uvm_info("MYTEST", "Hello", UVM_MEDIUM)
	endtask
endclass

module tb;
	initial begin
		$display("running tb");
		run_test("my_test");
	end
endmodule