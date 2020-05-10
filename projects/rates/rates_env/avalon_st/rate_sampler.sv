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

    rate_configuration configuration = null;

    /*-------------------------------------------------------------------------------
    -- Tasks & Functions.
    -------------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (string name = "rate_sampler", uvm_component parent = null);
        super.new(name, parent);

        this.configuration          = null;
    endfunction

    /*-------------------------------------------------------------------------------
    -- Build Phase.
    -------------------------------------------------------------------------------*/
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        // Create the configuration, Register to factory.
        this.configuration = rate_configuration::type_id::create("rate_configuration", this);
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
    -- Calc Fixed Rate.
    ------------------------------------------------------------------------------*/
    function real getFixedRateValidP(int DATA_WIDTH_IN_BYTES);

        // Set valid Prob according to rate calc
        // 
        // rate / bandwidth   (Rate in Gbps * 10**9) / DATA_WIDTH_IN_BYTES * 8
        // ---------------- = ------------------------------------------------
        // Cycle per second         10**9  / (CLK_CYCLE_TIME * 2)
        
        longint rate_per_bandwidth = (this.configuration.dest_rate_in_Gbps * 10**9) / (DATA_WIDTH_IN_BYTES * 8);
        
        // Can't access verification_pack::CLK_CYCLE_TIME
        longint ccps = 10**9 / ( int'(this.configuration.CLK_CYCLE_TIME) * 2);

        // Multiply by 100 to change from [0-1] to [0-100] probability range.
        real fixed_rate_valid_p = 100 * (real'(rate_per_bandwidth) / real'(ccps)); 

        return fixed_rate_valid_p;
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
        $display("Gbps = ", Gbps);
    endfunction

     /*------------------------------------------------------------------------------
    -- Check Rate Validity.
    ------------------------------------------------------------------------------*/
    function bit is_rate_valid();
        real rate = this.getRate();

        $display("rate  = ", rate );
        $display("this.configuration.dest_rate_in_Gbps = ", this.configuration.dest_rate_in_Gbps);

        if ( rate > (this.configuration.dest_rate_in_Gbps + this.configuration.deviation_percent_allowed / 100)) begin
            $display(" Rate is too damn high !",);
            return 1'b0;
        
        end else if ( rate < (this.configuration.dest_rate_in_Gbps - this.configuration.deviation_percent_allowed / 100)) begin
            $display(" Rate is low af !",);
            return 1'b0;

        end else begin
            $display("Not gonna lie, Rate is kinda lit though",);
            return 1'b1;
        end
    endfunction

     /*------------------------------------------------------------------------------
    -- Check Rate Stability.
    ------------------------------------------------------------------------------*/
    function bit is_rate_stable();

        // Stability = rate is dest rate
        return this.getRate() <= this.configuration.dest_rate_in_Gbps;
    endfunction



endclass
`endif // __RATE_SAMPLER
