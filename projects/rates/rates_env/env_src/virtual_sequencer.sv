`ifndef __VIRTUAL_SEQUENCER_NEW
`define __VIRTUAL_SEQUENCER_NEW

class virtual_sequencer extends uvm_sequencer;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_utils(virtual_sequencer)
    /*-------------------------------------------------------------------------------
    -- Data Members.
    -------------------------------------------------------------------------------*/
	msg_in_sequencer_type msg_in_sequencer = null;

    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass

`endif // __VIRTUAL_SEQUENCER_NEW
