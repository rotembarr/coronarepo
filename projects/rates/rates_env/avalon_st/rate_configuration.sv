
`ifndef __rate_configuration
`define __rate_configuration

class rate_configuration extends uvm_component;
    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
	
    // Destination Rate
	real dest_rate_in_Gbps = 0;

    // deviation percent allowed for a valid test
    real deviation_percent_allowed = 5;

    // Block clock.
    time CLK_CYCLE_TIME = 0ns;

    // configure the fixed rate amd burst probabilties
    int unsigned fixed_rate_p = 70;
    int unsigned burst_p      = 20;
    
    // fixed_rate_length ranges
    int unsigned min_fixed_rate_length = 90;
    int unsigned max_fixed_rate_length = 100;

    // burst_length ranges
    int unsigned min_burst_length = 0;
    int unsigned max_burst_length = 1000;

    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_utils_begin(rate_configuration)
		`uvm_field_real(dest_rate_in_Gbps , UVM_DEFAULT | UVM_UNSIGNED)
        `uvm_field_real(deviation_percent_allowed , UVM_DEFAULT | UVM_UNSIGNED)
        `uvm_field_int(fixed_rate_p , UVM_DEFAULT | UVM_UNSIGNED)
		`uvm_field_int(burst_p , UVM_DEFAULT | UVM_UNSIGNED)
        `uvm_field_int(min_fixed_rate_length , UVM_DEFAULT | UVM_UNSIGNED)
        `uvm_field_int(max_fixed_rate_length , UVM_DEFAULT | UVM_UNSIGNED)
        `uvm_field_int(min_burst_length , UVM_DEFAULT | UVM_UNSIGNED)
        `uvm_field_int(max_burst_length , UVM_DEFAULT | UVM_UNSIGNED)
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
    function new (string name = "rate_configuration", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    /*------------------------------------------------------------------------------
    -- Build Phase.
    ------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        
        // Get clk time.
        if (!uvm_config_db #(time)::get(this, "", "CLK_CYCLE_TIME", this.CLK_CYCLE_TIME)) begin
            `uvm_fatal(this.get_name().toupper(), "Could not find the rate configuration CLK_CYCLE_TIME in the test.");
        end

        // Get Dest rate.
        if (!uvm_config_db #(real)::get(this, "", "dest_rate_in_Gbps", this.dest_rate_in_Gbps)) begin
            `uvm_fatal(this.get_name().toupper(), "Could not find the rate configuration dest_rate_in_Gbps in the test.");
        end

    endfunction

    /*------------------------------------------------------------------------------
    -- Run Phase.
    ------------------------------------------------------------------------------*/
    virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);
    endtask
endclass

`endif // __rate_configuration