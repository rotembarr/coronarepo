
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
    rand byte data_queue_in_bytes[$] = {};
    rand int  data_size_in_bytes     = 0;

    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    constraint data_in_bytes_size_constraint {
        solve data_size_in_bytes before data_queue_in_bytes;
        data_queue_in_bytes.size() == data_size_in_bytes;
    };

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "msg_sequence");
        super.new(name);

        data_queue_in_bytes = {};
        data_size_in_bytes  = 0;
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
      this.randomize() with {data_size_in_bytes inside{[1:100]};};
      
        `uvm_do_on_with(req, p_sequencer, {
            data_in_bytes.size() == data_queue_in_bytes.size();
            foreach(data_in_bytes[idx]) {
                data_in_bytes[idx] == data_queue_in_bytes[idx];
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