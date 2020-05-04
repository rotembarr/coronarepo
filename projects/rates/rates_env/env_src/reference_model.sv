
`ifndef __REFERENCE_MODEL
`define __REFERENCE_MODEL

class reference_model extends uvm_component;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_utils(reference_model)

    /*-------------------------------------------------------------------------------
    -- Ports Declartions.
    -------------------------------------------------------------------------------*/
    `uvm_analysis_imp_decl(_msg_in_port)

    /*-- Ports --------------------------------------------------------------------*/
    uvm_analysis_imp_msg_in_port #(msg_in_item_type, reference_model) msg_in_port = null;
    /*-- Exports ------------------------------------------------------------------*/
    uvm_analysis_port #(msg_out_item_type) msg_out_export = null;

    /*-------------------------------------------------------------------------------
    -- Reference Model members.
    -------------------------------------------------------------------------------*/

    /*-------------------------------------------------------------------------------
    -- msg_in Write Function.
    -------------------------------------------------------------------------------*/
    function void write_msg_in_port (msg_in_item_type item = null);
		// connecting directly
      	this.msg_out_export.write(item);
    endfunction

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "reference_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    /*-------------------------------------------------------------------------------
    -- Build Phase.
    -------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

       /*-- Ports Initialization --------------------------------------------------*/
        this.msg_in_port    = new("msg_in_port", this);
        this.msg_out_export = new("msg_out_export", this);

    endfunction

    /*-------------------------------------------------------------------------------
    -- End of Elaboration Phase.
    -------------------------------------------------------------------------------*/
    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

endclass

`endif // __REFERENCE_MODEL
