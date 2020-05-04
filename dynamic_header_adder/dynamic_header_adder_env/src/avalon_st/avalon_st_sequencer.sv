`ifndef __AVALON_ST_SEQUENCER
`define __AVALON_ST_SEQUENCER

class avalon_st_sequencer #(
  					parameter int unsigned DATA_WIDTH_IN_BYTES = 4)
  extends uvm_sequencer #(avalon_st_sequence_item #(DATA_WIDTH_IN_BYTES));
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
  	`uvm_component_utils(avalon_st_sequencer #(DATA_WIDTH_IN_BYTES))
  	

    /*-------------------------------------------------------------------------------
    -- Data Members.
    -------------------------------------------------------------------------------*/
	//msg_in_sequencer_type msg_in_sequencer = null;

    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass

`endif // __AVALON_ST_SEQUENCER
