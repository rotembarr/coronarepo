
`ifndef __TOP_TB
`define __TOP_TB

//`include "dependencies.sv"

module top_tb ();
	
  	import uvm_pkg::*;

    /*------------------------------------------------------------------------------
    -- Local Signals.
    ------------------------------------------------------------------------------*/
    bit         clk = 1'b0;
    //reset_if    rst          (.clk(clk));
  	bit			rst;
    /*------------------------------------------------------------------------------
    -- Interfaces.
    ------------------------------------------------------------------------------*/
    avalon_st_if #(verification_pack::DATA_WIDTH_IN_BYTES) header_in(.clk(clk));
	avalon_st_if #(verification_pack::DATA_WIDTH_IN_BYTES) msg_in(.clk(clk));
	avalon_st_if #(verification_pack::DATA_WIDTH_IN_BYTES) msg_out(.clk(clk));

    /*------------------------------------------------------------------------------
    -- Module declaration.
    ------------------------------------------------------------------------------*/
	
    dynamic_header_adder # ( 
            .DATA_WIDTH_IN_BYTES(verification_pack::DATA_WIDTH_IN_BYTES)
    )
    dynamic_header_adder_inst
    (
        .clk(clk),
        .rst(rst),

        // interfaces
        .msg_in_st(msg_in),
        .header_in_st(header_in),
        .msg_out_st(msg_out)
    );

    /*------------------------------------------------------------------------------
    -- Clock.
    ------------------------------------------------------------------------------*/
    always begin
        #verification_pack::CLK_CYCLE_TIME clk = ~clk;
    end

    /*------------------------------------------------------------------------------
    -- Set up environment.
    ------------------------------------------------------------------------------*/
    initial begin
        //rst.rst = 1'b1;
		rst = 1'b1;
      
        // Set reset interface.
        //uvm_config_db #(virtual reset_if)::set(null, "*", "rst", rst);
      	uvm_config_db #(bit)::set(null, "*", "rst", rst);


        // Set interfaces.
        uvm_config_db #(virtual avalon_st_if  #(verification_pack::DATA_WIDTH_IN_BYTES))::set(null, "*.header_in_agent.*", "vif", header_in);
		uvm_config_db #(virtual avalon_st_if  #(verification_pack::DATA_WIDTH_IN_BYTES))::set(null, "*.msg_in_agent.*", "vif", msg_in);
		uvm_config_db #(virtual avalon_st_if  #(verification_pack::DATA_WIDTH_IN_BYTES))::set(null, "*.msg_out_agent.*", "vif", msg_out);

        // Set clock time.
        uvm_config_db #(time)::set(null, "*", "CLK_CYCLE_TIME", verification_pack::CLK_CYCLE_TIME);
    end

    /*------------------------------------------------------------------------------
    -- Run Test.
    ------------------------------------------------------------------------------*/
    initial begin
      // required in order to open EPWave
	  $dumpfile("dump.vcd");
      $dumpvars(0,top_tb);
      
        // Start the test.
      uvm_root::get().run_test("base_test");
    end
endmodule

`endif // __TOP_TB