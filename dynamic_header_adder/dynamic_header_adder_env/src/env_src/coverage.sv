class coverage extends uvm_component;

    `uvm_component_utils(coverage)

    `uvm_analysis_imp_decl(_msg_port)
    `uvm_analysis_imp_decl(_header_port)

    uvm_analysis_imp_msg_port    #(msg_in_item_type, coverage)    msg_port    = null;
    uvm_analysis_imp_header_port #(header_in_item_type, coverage) header_port = null;



    /*-------------------------------------------------------------------------------
    -- Coverage members.
    -------------------------------------------------------------------------------*/
    header_in_item_type header_item_q[$];   // a queue to hold all incoming headers
    msg_in_item_type    msg_item_q[$];      // a queue to hold all incoming messages


    /*-------------------------------------------------------------------------------
    -- Coverage variable.
    -------------------------------------------------------------------------------*/
    covergroup header_size_covergroup;
        header_size_relation_to_bus : coverpoint this.header_item_q[$].data_in_bytes.size(){
        bins header_smaller_then_bus_width = {[0 : verification_pack::DATA_WIDTH_IN_BYTES - 1]};
        bins header_equal_to_bus_width     = {verification_pack::DATA_WIDTH_IN_BYTES};
        bins header_larger_then_bus_width  = {[verification_pack::DATA_WIDTH_IN_BYTES + 1 : $]};
        }

        header_bus_alignment : coverpoint (this.header_item_q[$].data_in_bytes.size() % verification_pack::DATA_WIDTH_IN_BYTES){
        bins header_align_with_bus_width     = {0};
        bins header_not_align_with_bus_width = default;
        }

        cross header_size_relation_to_bus, header_bus_alignment;
    endgroup

    covergroup messege_size_covergroup;
        message_size_relation_to_bus : coverpoint this.msg_item_q[$].data_in_bytes.size(){
        bins message_smaller_then_bus_width = {[0 : verification_pack::DATA_WIDTH_IN_BYTES - 1]};
        bins message_equal_to_bus_width     = {verification_pack::DATA_WIDTH_IN_BYTES};
        bins message_larger_then_bus_width  = {[verification_pack::DATA_WIDTH_IN_BYTES + 1 : $]};
        }

        message_bus_alignment : coverpoint (this.msg_item_q[$].data_in_bytes.size() % verification_pack::DATA_WIDTH_IN_BYTES){
        bins message_align_with_bus_width     = {0};
        bins message_not_align_with_bus_width = default;
        }

        cross message_size_relation_to_bus, message_bus_alignment;
    endgroup


    covergroup header_message_covergroup;
        header_message_ratio : coverpoint this.header_item_q.size(){
        bins header_before_message = {[0 : this.msg_item_q.size() - 1]};
        bins header_after_message = {[this.msg_item_q.size() + 1 : $]};
        }     
    endgroup

    /*-------------------------------------------------------------------------------
    -- msg_in Write Function.
    -------------------------------------------------------------------------------*/
    function void write_msg_port (msg_in_item_type item = null);
        // add the message to the queue
        this.msg_item_q = {this.msg_item_q, item};

        this.messege_size_covergroup.sample();
    
    endfunction

    /*-------------------------------------------------------------------------------
    -- header_in Write Function.
    -------------------------------------------------------------------------------*/
    function void write_header_port (header_in_item_type item = null);
        // add the header to the queue
        this.header_item_q = {this.header_item_q, item};
        
        this.header_size_covergroup.sample();
        this.header_message_covergroup.sample();
    endfunction

	/*-------------------------------------------------------------------------------
	-- Tasks & Functions.
	-------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        this.msg_port           = new("msg_port", this);
        this.header_port        = new("header_port", this);

    endfunction

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "coverage", uvm_component parent = null);
        super.new(name, parent);

        this.msg_port           = null;
        this.header_port        = null;

        this.header_item_q = {};
        this.msg_item_q    = {};

    	this.messege_size_covergroup = new();
        this.header_size_covergroup = new();
        this.header_message_covergroup = new();
	endfunction


endclass