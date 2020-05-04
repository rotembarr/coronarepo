`ifndef __VIRTUAL_SEQ
`define __VIRTUAL_SEQ

class virtual_sequence extends uvm_sequence;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_object_utils(virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    /*------------------------------------------------------------------------------
    -- Parameters.
    ------------------------------------------------------------------------------*/
    generation_parameters parameters = null;

    /*------------------------------------------------------------------------------
    -- Sizes Constraints.
    ------------------------------------------------------------------------------*/

	/*-----------------------------------------------------------------------------------
	-- Nested Sequences.
	-----------------------------------------------------------------------------------*/
    msg_sequence message_sequence = null;
    hdr_sequence header_sequence  = null;

    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "virtual_sequence");
        super.new(name);

    endfunction

    /*-------------------------------------------------------------------------------
    -- Pre Start.
    -------------------------------------------------------------------------------*/
    virtual task pre_start ();
        if ((get_parent_sequence() == null) && (starting_phase != null)) begin
            starting_phase.raise_objection(this);
        end
    endtask

    /*-------------------------------------------------------------------------------
    -- Body.
    -------------------------------------------------------------------------------*/
    virtual task body ();
        time msg_delay_time     = 0ns;
        time header_delay_time  = 0ns;
        
        // Sending pairs of headers and messages in parallel 
        fork
            
            // Send headers to the sequencer.
            for (int i = 0; i < this.parameters.header_seq_num_of_calls; i++) begin
                
                // randomize delay time before sending a header
                std::randomize(header_delay_time) with {
                    header_delay_time dist {
                        this.parameters.MIN_DELAY_TIME                                    :/ this.parameters.MIN_DELAY_TIME_P,
                        [this.parameters.MIN_DELAY_TIME : this.parameters.MAX_DELAY_TIME] :/ 100 - this.parameters.MIN_DELAY_TIME_P
                    };
                };

                #header_delay_time;

                // Send the header
                `uvm_do_on(header_sequence, p_sequencer.header_in_sequencer)

            end

            // Send messages to the sequencer.
            for (int i = 0; i < this.parameters.msg_seq_num_of_calls; i++) begin

                // randomize delay time before sending a message
                std::randomize(msg_delay_time) with {
                    msg_delay_time dist {
                        this.parameters.MIN_DELAY_TIME                                    :/ this.parameters.MIN_DELAY_TIME_P,
                        [this.parameters.MIN_DELAY_TIME : this.parameters.MAX_DELAY_TIME] :/ 100 - this.parameters.MIN_DELAY_TIME_P
                    };
                };

                #msg_delay_time;

                // Send the msg
                `uvm_do_on(message_sequence, p_sequencer.msg_in_sequencer)
            end

        join_any

        
    endtask

    /*------------------------------------------------------------------------------
    -- Pre randomize.
    ------------------------------------------------------------------------------*/
    function void pre_randomize();
        // Get the parameters from the test.
        if(!uvm_config_db #(generation_parameters)::get(null, this.get_full_name(), "parameters", this.parameters)) begin
            `uvm_fatal(this.get_name().toupper(), "Couldn't find the generation parameters")
        end

    endfunction

    /*-------------------------------------------------------------------------------
    -- Post Start.
    -------------------------------------------------------------------------------*/
    virtual task post_start ();
        if ((get_parent_sequence() == null) && (starting_phase != null)) begin
            starting_phase.drop_objection(this);
        end
    endtask
endclass

`endif // __VIRTUAL_SEQ