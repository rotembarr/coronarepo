
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
    `uvm_analysis_imp_decl(_header_in_port)

    /*-- Ports --------------------------------------------------------------------*/
    uvm_analysis_imp_msg_in_port    #(msg_in_item_type, reference_model)    msg_in_port    = null;
    uvm_analysis_imp_header_in_port #(header_in_item_type, reference_model) header_in_port = null;
    /*-- Exports ------------------------------------------------------------------*/
    uvm_analysis_port #(msg_out_item_type) msg_out_export = null;

    /*-------------------------------------------------------------------------------
    -- Reference Model members.
    -------------------------------------------------------------------------------*/
    header_in_item_type header_item_q[$];   // a queue to hold all incoming headers
    msg_in_item_type    msg_item_q[$];      // a queue to hold all incoming messages

    /*-------------------------------------------------------------------------------
    -- msg_in Write Function.
    -------------------------------------------------------------------------------*/
    function void write_msg_in_port (msg_in_item_type item = null);
		// add the message to the queue
        this.msg_item_q = {this.msg_item_q, item};
    
    endfunction

    /*-------------------------------------------------------------------------------
    -- header_in Write Function.
    -------------------------------------------------------------------------------*/
    function void write_header_in_port (header_in_item_type item = null);
        // add the header to the queue
        this.header_item_q = {this.header_item_q, item};
        
    endfunction

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "reference_model", uvm_component parent = null);
        super.new(name, parent);

        this.header_item_q = {};
        this.msg_item_q    = {};

    endfunction

    /*-------------------------------------------------------------------------------
    -- Build Phase.
    -------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

       /*-- Ports Initialization --------------------------------------------------*/
        this.header_in_port = new("header_in_port", this);
        this.msg_in_port    = new("msg_in_port", this);
        this.msg_out_export = new("msg_out_export", this);

    endfunction

    /*-------------------------------------------------------------------------------
    -- End of Elaboration Phase.
    -------------------------------------------------------------------------------*/
    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

    /*------------------------------------------------------------------------------
    -- Run Phase.
    ------------------------------------------------------------------------------*/
    virtual task run_phase(uvm_phase phase);
        
        header_in_item_type header_in_item; // Incoming header item from the queue 
        msg_in_item_type    msg_in_item;    // Incoming message item from the queue
        msg_out_item_type   msg_out_item;   // outgoing message item

        super.run_phase(phase);

        header_in_item = new();
        msg_in_item    = new();
        msg_out_item   = new();

        forever begin

            // wait for header item
            wait (this.header_item_q.size() != 0);
            header_in_item = this.header_item_q.pop_front();

            // wait for message item
            wait (this.msg_item_q.size() != 0);
            msg_in_item = this.msg_item_q.pop_front();
            
            msg_out_item.data_in_bytes = {header_in_item.data_in_bytes, msg_in_item.data_in_bytes};

            this.msg_out_export.write(msg_out_item);

        end

    endtask : run_phase


endclass



`endif // __REFERENCE_MODEL
