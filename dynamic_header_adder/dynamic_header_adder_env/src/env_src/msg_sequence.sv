
`ifndef REMOVER_MSG_SEQ
`define REMOVER_MSG_SEQ

class msg_sequence extends uvm_sequence #(avalon_st_sequence_item #(verification_pack::DATA_WIDTH_IN_BYTES));
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_object_utils(msg_sequence)
    `uvm_declare_p_sequencer(avalon_st_sequencer #(verification_pack::DATA_WIDTH_IN_BYTES))

    /*------------------------------------------------------------------------------
    -- Parameters.
    ------------------------------------------------------------------------------*/
    generation_parameters parameters = null;

    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    rand byte data_bytes_queue[$] = {};

    /*------------------------------------------------------------------------------
    -- Constraints.
    ------------------------------------------------------------------------------*/
    constraint data_bytes_queue_size_constraint {
        this.data_bytes_queue.size() >= this.parameters.MIN_MSG_SIZE_IN_BYTES;
        this.data_bytes_queue.size() <= this.parameters.MAX_MSG_SIZE_IN_BYTES;
    };

    // constraint to align the message to the bus width
    /*constraint data_bytes_queue_size_word_aligned_constraint{
        this.data_bytes_queue.size()%verification_pack::DATA_WIDTH_IN_BYTES == 0;
    };*/

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "msg_sequence");
        super.new(name);

        this.data_bytes_queue = {};
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
        // Send a Messege.
      
        `uvm_do_on_with(req, p_sequencer, {
            data_in_bytes.size() == this.data_bytes_queue.size();
            
            foreach(data_in_bytes[idx]) {
                data_in_bytes[idx] == this.data_bytes_queue[idx];
            }
		})
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

`endif // VIRTUAL_SEQ