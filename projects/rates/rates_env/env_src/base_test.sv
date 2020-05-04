`ifndef __BASE_TEST
`define __BASE_TEST

class base_test extends uvm_test;
    /*-----------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -----------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_utils(base_test)

    /*-----------------------------------------------------------------------------------
    -- Test Utils.
    -----------------------------------------------------------------------------------*/
    // Test's environment.
    environment env = null;

    // Test's generation parameters.
    generation_parameters parameters = null;

    // Block clock.
    time CLK_CYCLE_TIME = 0ns;

    /*-----------------------------------------------------------------------------------
    -- Tasks & Functions.
    -----------------------------------------------------------------------------------*/
    /*-----------------------------------------------------------------------------------
    -- Constructor.
    -----------------------------------------------------------------------------------*/
    function new (string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
        
        this.env = null;
        this.parameters  = null;
    
    endfunction

    /*-----------------------------------------------------------------------------------
    -- Build Phase.
    -----------------------------------------------------------------------------------*/
    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        // Set test properties.
        uvm_root::get().enable_print_topology =  verification_pack::TOPOLOGY;
        uvm_root::get().finish_on_completion  = !verification_pack::INFINITE;

        // Get clk time.
        if (!uvm_config_db #(time)::get(this, "", "CLK_CYCLE_TIME", this.CLK_CYCLE_TIME)) begin
            `uvm_fatal(this.get_name().toupper(), "Could not find the generation CLK_CYCLE_TIME in the test.");
        end

        // Create environment.
        this.env = environment::type_id::create("env", this);
        
        /*-- Parameters ----------------------------------------------------------------*/
        this.parameters = new("parameters");
        uvm_config_db #(generation_parameters)::set(this, "*", "parameters", this.parameters);

        /*-- Agent Configuration -------------------------------------------------------*/
		// msg_in Agent. [Avalon ST]
		uvm_config_db #(uvm_active_passive_enum)       ::set(this.env, "msg_in_agent*",              "is_active",         UVM_ACTIVE);
		uvm_config_db #(verification_master_slave_enum)::set(this.env, "msg_in_agent.configuration", "is_master",         MASTER);

		// msg_out Agent. [Avalon ST]
		uvm_config_db #(uvm_active_passive_enum)       ::set(this.env, "msg_out_agent*",              "is_active",         UVM_ACTIVE);
		uvm_config_db #(verification_master_slave_enum)::set(this.env, "msg_out_agent.configuration", "is_master",         SLAVE);


    endfunction

    /*-----------------------------------------------------------------------------------
    -- Connect Phase.
    -----------------------------------------------------------------------------------*/
    virtual function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        // Set virtual sequence.
        uvm_config_db #(uvm_object_wrapper)::set(
            this.env,
            "virtual_sqr.main_phase",
            "default_sequence",
            virtual_sequence::get_type()
        );

    endfunction

    /*-----------------------------------------------------------------------------------
    -- Run Phase.
    -----------------------------------------------------------------------------------*/
    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);

        `uvm_info ( "SEED",$psprintf("The Seed Is: %d ", $get_initial_random_seed()) , UVM_MEDIUM );

        /*-- Set Timeout ----------------------------------------------------------------
        -- Determines when the simulation will end and under which conditions:
        --    * Run a normal scenario - no timeout, definite end.
        --    Conditions: messages need to be sent [MAX MESSAGES != 0], timeout must be 0.
        --    * Run a normal scenario - with timeout.
        --    Conditions: messages need to be sent [MAX MESSAGES != 0], timeout different than 0.
        --    * Run an infinite scenario.
        --    Conditions: turn the INFINITE flag on, send messages [MAX MESSAGES != 0].
        --    * Run a normal scenario - hard timeout.
        --    Confitions: set a timeout, send messages [MAX MESSAGES != 0].
        -------------------------------------------------------------------------------*/
        if (verification_pack::MAX_MESSAGES != 0) begin
            uvm_root::get().set_timeout(verification_pack::TIMEOUT);
        end else begin
            wait (!verification_pack::INFINITE);
            wait (verification_pack::TIMEOUT);
            $finish();
        end
    endtask
endclass

`endif // __BASE_TEST
