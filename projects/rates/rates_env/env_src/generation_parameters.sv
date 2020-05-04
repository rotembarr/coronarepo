
`ifndef __generation_parameters
`define __generation_parameters

class generation_parameters extends uvm_object;
   

    /*-------------------------------------------------------------------------------
    -- Data members.
    -------------------------------------------------------------------------------*/

    /*-------------------------------------------------------------------------------
    -- Seq num of Calls.
    -------------------------------------------------------------------------------*/
    int unsigned msg_seq_num_of_calls = 100;

    /*------------------------------------------------------------------------------
    -- Messege, Ready
    ------------------------------------------------------------------------------*/

    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_object_utils_begin(generation_parameters)
        `uvm_field_int(msg_seq_num_of_calls , UVM_ALL_ON | UVM_UNSIGNED)
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
