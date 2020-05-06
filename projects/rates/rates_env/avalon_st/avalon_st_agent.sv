
`ifndef __AVALON_ST_AGENT
`define __AVALON_ST_AGENT

class avalon_st_agent #(
    parameter int unsigned DATA_WIDTH_IN_BYTES = 4,
    parameter int unsigned DEST_RATE_IN_Gbps = 4
) extends uvm_agent;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_param_utils(avalon_st_agent #(DATA_WIDTH_IN_BYTES))

    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    // Agent Components.
    avalon_st_configuration                             configuration      = null;
    avalon_st_monitor            #(DATA_WIDTH_IN_BYTES) monitor            = null;
    avalon_st_driver             #(DATA_WIDTH_IN_BYTES) driver             = null;
    avalon_st_sequencer          #(DATA_WIDTH_IN_BYTES) sequencer          = null;

    // Rate sampler
    rate_sampler if_rate_sampler = null;

    // Agent export port.
    uvm_analysis_port #(avalon_st_monitor_item #(DATA_WIDTH_IN_BYTES))	data_export   = null;

    /*------------------------------------------------------------------------------
    -- Functions & Tasks declarations.
    ------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
    -- Constructor.
    ------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_agent", uvm_component parent = null);
        super.new(name, parent);

        // Initialize data members.
        this.configuration          = null;
        this.monitor                = null;
        this.driver                 = null;
        this.sequencer              = null;
        this.if_rate_sampler        = null;
        this.data_export            = null;
    endfunction

    /*------------------------------------------------------------------------------
    -- Build Phase.
    ------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        // Make the agent passive by default.
        if (!uvm_config_db #(uvm_active_passive_enum)::exists(this, "", "is_active", 1'b0)) begin
            this.is_active = UVM_PASSIVE;
        end

        // Create the configuration, Register to factory.
        this.configuration = avalon_st_configuration::type_id::create("configuration", this);

        // Set the configuration in the factory.
        uvm_config_db #(avalon_st_configuration)::set(this, "*", "configuration", this.configuration);

        // Create the monitor, Register to factory.
        this.monitor = avalon_st_monitor #(DATA_WIDTH_IN_BYTES)::type_id::create("monitor", this);

        // Check if the agent is passive or active.
        if ((this.get_is_active() == UVM_ACTIVE)) begin
            // Create the driver, Register to factory.
            this.driver = avalon_st_driver #(DATA_WIDTH_IN_BYTES)::type_id::create("driver", this);

            // Create the sequencer if the agent is MASTER, Register to factory.
            if (this.configuration.is_master == MASTER) begin
                this.sequencer = avalon_st_sequencer #(DATA_WIDTH_IN_BYTES)::type_id::create("sequencer", this);
            end
        end

        // Create the rate sampler
        this.if_rate_sampler = rate_sampler::type_id::create ("if_rate_sampler", this);
        
        // Set the configuration in the factory.
        uvm_config_db #(rate_sampler)::set(this, "*", "if_rate_sampler", this.if_rate_sampler);

        // Create the analysis port for the agent.
        this.data_export               = new("data_export", this);
    endfunction

    /*------------------------------------------------------------------------------
    -- Connect Phase.
    ------------------------------------------------------------------------------*/
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        // Connect the monitor to the analysis port of the agent.
        this.monitor.data_export.connect(this.data_export);

        // Connect the sequencer to the driver (if there is a sequencer).
        if ((this.get_is_active() == UVM_ACTIVE) && (this.configuration.is_master == MASTER)) begin
            // Connect the driver pull port to the sequencer.
            this.driver.seq_item_port.connect(this.sequencer.seq_item_export);
        end
    endfunction


    /*-------------------------------------------------------------------------------
    -- Extract Phase.
    -------------------------------------------------------------------------------*/
   virtual function void check_phase (uvm_phase phase);
       super.check_phase(phase);

        //Connect to the reporter. For now, print the results.
        this.if_rate_sampler.printe_rate();
        this.if_rate_sampler.is_rate_valid(this.configuration.dest_rate_in_Gbps, this.configuration.deviation_percent_allowed);
        // this.if_rate_sampler.check_rate(4, this.configuration.deviation_percent_allowed);

   endfunction
endclass

`endif // __AVALON_ST_AGENT