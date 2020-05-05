`ifndef __RATE_SAMPLER
`define __RATE_SAMPLER

class rate_sampler #(int unsigned  DEST_RATE = 0, int unsigned DEVIATION_PERCENT_ALLOWED = 0) extends uvm_component;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_param_utils(rate_sampler #(DEST_RATE, DEVIATION_PERCENT_ALLOWED))

    /*-------------------------------------------------------------------------------
    -- Data Members.
    -------------------------------------------------------------------------------*/
    longint bits_recorded = 0;
    time start_time = 0;
    time end_time = 0;

    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "rate_sampler", uvm_component parent = null);
        super.new(name, parent);

    endfunction

    /*-------------------------------------------------------------------------------
    -- Build Phase.
    -------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);


    endfunction

    /*-------------------------------------------------------------------------------
    -- Write.
    -------------------------------------------------------------------------------*/
    virtual function void write (int num_of_bits);
        this.bits_recorded += num_of_bits;

    endfunction

    /*------------------------------------------------------------------------------
    -- Calc rate.
    ------------------------------------------------------------------------------*/
  function real getRate();
        return real'(this.bits_recorded) / real'($time() - this.start_time);
        
    endfunction

    /*------------------------------------------------------------------------------
    -- Print.
    ------------------------------------------------------------------------------*/
  function void printe_rate();
    // Rate = bit per ns as its the time precision unit
    real rate = 0;
    real bps  = 0;
    real Mbps = 0;
    real Gbps = 0;

    rate = this.getRate();
    bps = rate * 10**9;
    Mbps = bps / 10**6;
    Gbps = bps / 10**9;

    
    $display("this.bits_recorded  = ", this.bits_recorded);
    $display("$time= ", $time);
    $display("this.start_time = ", int'(this.start_time));
    $display("Rate = ", rate);
    $display("bps = ", bps);
    $display("Mbps = ", Mbps);
    $display("Gbps = ", Gbps);

    
    endfunction


    /*-------------------------------------------------------------------------------
    -- Extract Phase.
    -------------------------------------------------------------------------------*/
   virtual function void extract_phase (uvm_phase phase);
       super.extract_phase(phase);

        //Connect to the reporter. For now, print the results.
        this.printe_rate();

   endfunction

endclass
`endif // __RATE_SAMPLER
