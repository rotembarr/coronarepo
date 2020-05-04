class coverage extends uvm_component;

    `uvm_component_utils(coverage)

    `uvm_analysis_imp_decl(_msg_port)
    uvm_analysis_imp_msg_port #(msg_in_item_type, coverage) msg_port = null;

    /*-------------------------------------------------------------------------------
	-- Coverage variable.
	-------------------------------------------------------------------------------*/

    covergroup messege_covergroup;

    endgroup

	/*-------------------------------------------------------------------------------
	-- Tasks & Functions.
	-------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        this.msg_port           = new("msg_port", this);
    endfunction

    function void write_msg_port (msg_in_item_type item);

        this.messege_covergroup.sample();
    endfunction
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "coverage", uvm_component parent = null);
        super.new(name, parent);

        this.msg_port           = null;
    	this.messege_covergroup = new();
	endfunction


endclass