
`ifndef __ENVIRONMENT
`define __ENVIRONMENT

class environment extends uvm_env;
    /*-----------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -----------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_utils(environment)

    /*-----------------------------------------------------------------------------------
    -- Agents.
    -----------------------------------------------------------------------------------*/
	msg_in_agent_type  msg_in_agent  = null;
	msg_out_agent_type msg_out_agent = null;

    /*-----------------------------------------------------------------------------------
    -- Sequencers.
    -----------------------------------------------------------------------------------*/
	virtual_sequencer virtual_sqr = null;

    /*-----------------------------------------------------------------------------------
    -- Reference Model.
    -----------------------------------------------------------------------------------*/
    reference_model ref_model = null;

    /*-----------------------------------------------------------------------------------
    -- Scoreboards.
    -----------------------------------------------------------------------------------*/
    msg_out_scoreboard_type msg_out_scoreboard = null;

    /*-----------------------------------------------------------------------------------
    -- Scoreboards.
    -----------------------------------------------------------------------------------*/
    coverage covrg = null;

    /*-----------------------------------------------------------------------------------
    -- Tasks & Functions.
    -----------------------------------------------------------------------------------*/
    /*-----------------------------------------------------------------------------------
    -- Constructor.
    -----------------------------------------------------------------------------------*/
    function new (string name = "environment", uvm_component parent = null);
        super.new(name, parent);

        // Agents.
		this.msg_in_agent  = null;
		this.msg_out_agent = null;

        // Components.
        this.ref_model    = null;

        // Scoreborads.
        this.msg_out_scoreboard = null;

        // Coverage
        covrg = null;
    endfunction

    /*-----------------------------------------------------------------------------------
    -- Build Phase.
    -----------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        /*-- Build Agents -------------------------------------------------------------*/
		this.msg_in_agent  = msg_in_agent_type ::type_id::create("msg_in_agent", this);
		this.msg_out_agent = msg_out_agent_type::type_id::create("msg_out_agent", this);

        /*-- Build Components ---------------------------------------------------------*/
		this.virtual_sqr = virtual_sequencer::type_id::create("virtual_sqr", this);
        this.ref_model = reference_model::type_id::create("ref_model", this);

        /*-- Build Scoreboards --------------------------------------------------------*/
        this.msg_out_scoreboard = msg_out_scoreboard_type::type_id::create("msg_out_scoreboard", this);

        /*-- Build Coverage -----------------------------------------------------------*/
        this.covrg = coverage::type_id::create("covrg", this);

    endfunction

    /*-----------------------------------------------------------------------------------
    -- Connect Phase.
    -----------------------------------------------------------------------------------*/
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);

        /*-- Connect Sequencers -------------------------------------------------------*/
		this.virtual_sqr.msg_in_sequencer = this.msg_in_agent.sequencer;

		/*-- Connect Reference Model --------------------------------------------------*/
        this.msg_in_agent.data_export.connect(this.ref_model.msg_in_port);

        /*-- Connect Scoreboards ------------------------------------------------------*/
        this.msg_out_agent  .data_export   .connect(this.msg_out_scoreboard.dut_port);
        this.ref_model.msg_out_export.connect(this.msg_out_scoreboard.env_port);

        /*-- Connect Coverage ---------------------------------------------------------*/
        this.msg_in_agent.data_export.connect(this.covrg.msg_port);

    endfunction

    /*-----------------------------------------------------------------------------------
    -- End of Elaboration Phase.
    -----------------------------------------------------------------------------------*/
    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction
endclass

`endif // __ENVIRONMENT
