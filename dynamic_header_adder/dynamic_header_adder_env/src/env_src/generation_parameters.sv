
`ifndef __generation_parameters
`define __generation_parameters

class generation_parameters extends uvm_object;
   

    /*-------------------------------------------------------------------------------
    -- Data members.
    -------------------------------------------------------------------------------*/

    /*-------------------------------------------------------------------------------
    -- Seq num of Calls.
    -------------------------------------------------------------------------------*/
    int unsigned msg_seq_num_of_calls    = 100;
    int unsigned header_seq_num_of_calls = 100;
    /*-------------------------------------------------------------------------------
    -- Delay times boundaries
    -------------------------------------------------------------------------------*/
    time MIN_DELAY_TIME = 0ns;
    time MAX_DELAY_TIME = 100ns;

    int unsigned MIN_DELAY_TIME_P = 30;
    /*------------------------------------------------------------------------------
    -- Header and Message sizes
    ------------------------------------------------------------------------------*/
    int unsigned MIN_HEADER_SIZE_IN_BYTES = 1;
    int unsigned MAX_HEADER_SIZE_IN_BYTES = 100;
    int unsigned MIN_MSG_SIZE_IN_BYTES = 1;
    int unsigned MAX_MSG_SIZE_IN_BYTES = 100;
    /*------------------------------------------------------------------------------
    -- Valid and Ready probabilities
    ------------------------------------------------------------------------------*/
    int unsigned MSG_IN_VALID_P    = 70;
    int unsigned HEADER_IN_VALID_P = 70;
    int unsigned MSG_OUT_RDY_P     = 70;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_object_utils_begin(generation_parameters)
        `uvm_field_int(msg_seq_num_of_calls ,     UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(header_seq_num_of_calls ,  UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MIN_DELAY_TIME_P ,         UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MIN_HEADER_SIZE_IN_BYTES , UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MAX_HEADER_SIZE_IN_BYTES , UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MIN_MSG_SIZE_IN_BYTES ,    UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MAX_MSG_SIZE_IN_BYTES ,    UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MSG_IN_VALID_P ,           UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(HEADER_IN_VALID_P ,        UVM_ALL_ON | UVM_UNSIGNED)
        `uvm_field_int(MSG_OUT_RDY_P ,            UVM_ALL_ON | UVM_UNSIGNED)

    `uvm_object_utils_end


    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "generation_parameters");
        super.new(name);

    endfunction
endclass

`endif // __generation_parameters
