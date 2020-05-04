
`ifndef __avalon_st_configuration
`define __avalon_st_configuration

class avalon_st_configuration extends uvm_component;
    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    verification_master_slave_enum is_master = MASTER;
	
	// configure the valid amd ready probabilties
	int valid_p = 70;
	int rdy_p 	= 70;
	
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_utils_begin(avalon_st_configuration)
        // Enums.
        `uvm_field_enum(verification_master_slave_enum, is_master, UVM_DEFAULT)
		
		`uvm_field_int(valid_p , UVM_DEFAULT | UVM_UNSIGNED)
		`uvm_field_int(rdy_p , UVM_DEFAULT | UVM_UNSIGNED)
    `uvm_component_utils_end

    /*------------------------------------------------------------------------------
    -- Constraints.
    ------------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------------
    -- Tasks & Functions declarations.
    ------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
    -- Constructor.
    ------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_configuration", uvm_component parent = null);
        super.new(name, parent);

        // Initialize data members.
        this.is_master = MASTER;
    endfunction

    /*------------------------------------------------------------------------------
    -- Build Phase.
    ------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        // Get config values.
        uvm_config_db #(verification_master_slave_enum)::get(this, "", "is_master", this.is_master);

    endfunction

    /*------------------------------------------------------------------------------
    -- Run Phase.
    ------------------------------------------------------------------------------*/
    virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);
    endtask
endclass

`endif // __avalon_st_configuration