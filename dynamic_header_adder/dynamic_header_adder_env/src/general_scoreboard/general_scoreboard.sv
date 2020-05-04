
`ifndef __SCOREBOARD
`define __SCOREBOARD

class general_scoreboard #(
        parameter type ITEM_TYPE          = uvm_object ,
        parameter time TIMEOUT            = 100us,
        parameter bit  TOGGLE_DUT_TIMEOUT = 1'b0,
        parameter bit  TOGGLE_REF_TIMEOUT = 1'b0,
        parameter bit  IGNORE_NULL        = 1'b1) extends uvm_component;
    typedef general_scoreboard #(ITEM_TYPE , TIMEOUT, TOGGLE_DUT_TIMEOUT, TOGGLE_REF_TIMEOUT, IGNORE_NULL) parametrized_general_scoreboard;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_param_utils(parametrized_general_scoreboard)

    /*-------------------------------------------------------------------------------
    -- Data Members.
    -------------------------------------------------------------------------------*/
    `uvm_analysis_imp_decl(_env)
    `uvm_analysis_imp_decl(_dut)

    /*-------------------------------------------------------------------------------
    -- Ports.
    -------------------------------------------------------------------------------*/
    // Environment port.
    uvm_analysis_imp_env #(ITEM_TYPE, parametrized_general_scoreboard) env_port = null;

    // DUT port.
    uvm_analysis_imp_dut #(ITEM_TYPE, parametrized_general_scoreboard) dut_port = null;

    /*-------------------------------------------------------------------------------
    -- Data Members.
    -------------------------------------------------------------------------------*/
    ITEM_TYPE env_queue [$];
    ITEM_TYPE dut_queue [$];

    string reference_model_error_text = "scoreboard didnt recieve an item for too long from reference model";
    string dut_error_text             = "scoreboard didnt recieve an item for too long from dut";

    bit message_recieved = 1'b0;

    /*------------------------------------------------------------------------------
    -- Class Input members
    ------------------------------------------------------------------------------*/
    event dut_item_recieved;
    event ref_item_recieved;

    /*-------------------------------------------------------------------------------
    -- Data Members.
    -------------------------------------------------------------------------------*/
    local int number_of_dut_items = 0;
    local int number_of_ref_items = 0;

    // Variables.
    int unsigned item_compared = 0;
    int unsigned total_drops_number = 0;

    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "general_scoreboard", uvm_component parent = null);
        super.new(name, parent);

    endfunction

    /*-------------------------------------------------------------------------------
    -- Build Phase.
    -------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        // Ports constructor.
        this.env_port = new("env_port", this);
        this.dut_port = new("dut_port", this);

    endfunction

    /*-------------------------------------------------------------------------------
    -- Phase Ready To End.
    -------------------------------------------------------------------------------*/
    function void phase_ready_to_end(uvm_phase phase);
        super.phase_ready_to_end(phase);

        // Dont raise objections if the rate limiter reference model won't send messages.
        if (phase.is(uvm_post_main_phase::get())) begin

            // Check if there are items left in the RM queue.
            if ((this.env_queue.size() > 0) || (this.dut_queue.size() > 0)) begin
                phase.raise_objection(this);

                fork
                    begin
                        wait ((this.env_queue.size() == 0) && (this.dut_queue.size() == 0));
                        phase.drop_objection(this);
                    end
                join_none
            end
        end
    endfunction

    /*-------------------------------------------------------------------------------
    -- Uvm Check Phase
    ---------------------------------------------------------------------------------
    -- checks if any items where recieved to the scoreboard in the whole test.
    -- in case non appeared an error is printed.
    -------------------------------------------------------------------------------*/
    function void uvm_check_phase (uvm_phase phase);
        if (!message_recieved) begin
            `uvm_error(this.get_name().toupper(), "no item recieved in scoreboard for the whole test. check why data is not flowing through the environment and reaching your scoreboard")
        end
        /* Code */
    endfunction

    /*-------------------------------------------------------------------------------
    -- Write ENV.
    -------------------------------------------------------------------------------*/
    function void write_env (ITEM_TYPE item);
        bit scoreboard_status = 0;
        if(uvm_config_db #(bit)::exists(this, "", "scoreboard_status")) begin
            uvm_config_db #(bit)::get(this, "", "scoreboard_status", scoreboard_status);
            if(scoreboard_status == 1'b0) begin
                return;
            end
        end
        if ((IGNORE_NULL == 1'b0) && (item == null)) begin
            `uvm_fatal(this.get_name().toupper(), "null item recieved from env in the Scoreboard.")
        end
        this.env_queue.push_back(item);

        // shuts down the first message timeout
        message_recieved = 1'b1;

        // Compare to the first env item.
        if (this.dut_queue.size() > 0) this.compare();
    endfunction

    /*-------------------------------------------------------------------------------
    -- Write DUT.
    -------------------------------------------------------------------------------*/
    function void write_dut (ITEM_TYPE item);
        bit scoreboard_status = 0;
        if(uvm_config_db #(bit)::exists(this, "", "scoreboard_status")) begin
            uvm_config_db #(bit)::get(this, "", "scoreboard_status", scoreboard_status);
            if(scoreboard_status == 1'b0) begin
                return;
            end
        end
        if ((IGNORE_NULL == 1'b0) && (item == null)) begin
            `uvm_fatal(this.get_name().toupper(), "null item recieved from dut in the Scoreboard.")
        end
        this.dut_queue.push_back(item);

        // shuts down the first message timeout
        message_recieved = 1'b1;

        // Compare to the first env item.
        if (this.env_queue.size() > 0) begin
            this.compare();
        end
    endfunction

    /*-------------------------------------------------------------------------------
    -- Compare.
    -------------------------------------------------------------------------------*/
    function void compare ();
        // Item to be compared.
        ITEM_TYPE env_item = null;
        ITEM_TYPE dut_item = null;

        // Get items.
        env_item = this.env_queue.pop_front();
        dut_item = this.dut_queue.pop_front();

        // Compare items
        if (!env_item.compare(dut_item)) begin

            // Print items.
            `uvm_fatal(this.get_name().toupper(),
                {"\n",
                "ENV ITEM: \n", env_item.sprint(),
                "DUT ITEM: \n", dut_item.sprint(),
                "\nItems compare failed.\n",
                $psprintf("The seed is: %0d", $get_initial_random_seed())})
        end else begin
            // Compare succeed.
            `uvm_info(this.get_name().toupper(),
                $psprintf("%0d Item compare succeeded ", ++this.item_compared),
                UVM_LOW)
        end
    endfunction

endclass


`endif // __SCOREBOARD
