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
    msg_sequence msg_sequence = null;

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
        int unsigned msg_size   = 0;
        time         delay_time = 0ns;
      
        // Send messeges to the sequencer.
        for (int i = 0; i < parameters.msg_seq_num_of_calls; i++) begin

            // Send the msg
       		`uvm_do_on_with(msg_sequence, p_sequencer.msg_in_sequencer, {
                data_size_in_bytes == msg_size;
			})

        end
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