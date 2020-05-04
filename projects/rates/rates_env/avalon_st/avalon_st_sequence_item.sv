
`ifndef __AVALON_ST_SEQUENCE_ITEM
`define __AVALON_ST_SEQUENCE_ITEM

class avalon_st_sequence_item #(
    parameter int unsigned DATA_WIDTH_IN_BYTES = 4
) extends uvm_sequence_item;

    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    rand byte data_in_bytes[$] = {};
    
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_object_param_utils_begin(avalon_st_sequence_item #(DATA_WIDTH_IN_BYTES))
        // Integral Queues.
        `uvm_field_queue_int(data_in_bytes, UVM_DEFAULT | UVM_HEX)
    `uvm_object_utils_end

    /*------------------------------------------------------------------------------
    -- Constraints.
    ------------------------------------------------------------------------------*/
    constraint data_size_constraint {
        data_in_bytes.size() < 10000;
    };

    /*------------------------------------------------------------------------------
    -- Tasks & Functions declarations.
    ------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
    -- Constructor
    ------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_sequence_item");
        super.new(name);

        // Initialize data members.
        this.data_in_bytes = {};
    endfunction
endclass

`endif // __AVALON_ST_SEQUENCE_ITEM