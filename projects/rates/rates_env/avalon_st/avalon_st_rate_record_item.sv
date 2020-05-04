
`ifndef __AVALON_ST_RATE_RECORD_ITEM
`define __AVALON_ST_RATE_RECORD_ITEM

class avalon_st_monitor_item #(
    parameter int unsigned DATA_WIDTH_IN_BYTES = 4
) extends uvm_object;
    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    longint bits_recorded = 0;
    time start_time = 0;
    time end_time = 0;

    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_object_param_utils_begin(avalon_st_monitor_item #(DATA_WIDTH_IN_BYTES))
        // Integral Queues.
        `uvm_field_queue_int(data_in_bytes,       UVM_DEFAULT | UVM_HEX | UVM_NOPACK)
    `uvm_object_utils_end

    /*------------------------------------------------------------------------------
    -- Tasks & Functions declarations.
    ------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
    -- Constructor.
    ------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_monitor_item");
        super.new(name);

        $display("Rate = ", this.getRate());
    endfunction

    /*------------------------------------------------------------------------------
    -- Calc rate.
    ------------------------------------------------------------------------------*/
  function time getRate();
        return this.bits_recorded / ($time - int(this.start_time));
        
    endfunction

    /*------------------------------------------------------------------------------
    -- Print.
    ------------------------------------------------------------------------------*/
  function void do_print ();
    $display("Rate = ", this.getRate());
        
    endfunction
endclass

`endif // __AVALON_ST_RATE_RECORD_ITEM