`ifndef __RATE_SAMPLER
`define __RATE_SAMPLER

class rate_sampler extends uvm_component;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_param_utils(rate_sampler)

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
        // $display("this.start_time = ", int'(this.start_time));
        $display("Rate = ", rate);
        $display("bps = ", bps);
        $display("Mbps = ", Mbps);
        $display("Gbps = ", Gbps);
    endfunction

    function bit is_rate_valid(real dest_rate_in_Gbps, real deviation_percent_allowed);
        real rate_devision = dest_rate_in_Gbps / this.getRate();

        $display("this.getRate()  = ", this.getRate() );
        $display("dest_rate_in_Gbps = ", dest_rate_in_Gbps);
        $display("rate_devision = ", rate_devision);

        if ( (deviation_percent_allowed / 100) > $abs(rate_devision)) begin
            $display(" Rate good",);
            return 1'b1;
        end else begin
            $display(" Rate bad",);
            return 1'b0;
        end
        
    endfunction 

    function bit is_rate_high(real dest_rate_in_Gbps, real deviation_percent_allowed);
        real rate_devision = dest_rate_in_Gbps / this.getRate();

        $display("is_rate_high : rate_devision = ", rate_devision);

        if ( rate_devision >= 0) begin
            return 1'b1;
        end else begin
            return 1'b0;
        end
        
    endfunction 

endclass
`endif // __RATE_SAMPLER
