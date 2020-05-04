
`ifndef __AVALON_ST_DRIVER
`define __AVALON_ST_DRIVER

class avalon_st_driver #(
    parameter int unsigned DATA_WIDTH_IN_BYTES = 4
) extends uvm_driver #(avalon_st_sequence_item #(DATA_WIDTH_IN_BYTES));
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/

    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_param_utils(avalon_st_driver #(DATA_WIDTH_IN_BYTES))

    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    // Virtual interface.
    virtual avalon_st_if #(DATA_WIDTH_IN_BYTES) vif = null;

    // Agent configuration.
    avalon_st_configuration configuration = null;

    // Synchronize with clock-block event.
    event posedge_clk;

    /*------------------------------------------------------------------------------
    -- Constructor.
    ------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_driver", uvm_component parent = null);
        super.new(name, parent);

        // Initialize data members.
        this.vif           = null;
        this.configuration = null;
    endfunction

    /*------------------------------------------------------------------------------
    -- Build Phase.
    ------------------------------------------------------------------------------*/
    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);

        // Connect the configuration to the driver.
        if (!uvm_config_db #(avalon_st_configuration)::get(this, "", "configuration", this.configuration)) begin
            `uvm_fatal(this.get_name().toupper(), {"Driver did not find avalon_st_configuration in the environment: ", this.get_full_name(), ".configuration"});
        end

        // Connect the driver to the interface.
        if (!uvm_config_db #(virtual avalon_st_if #(DATA_WIDTH_IN_BYTES))::get(this, "", "vif", this.vif)) begin
            `uvm_fatal(this.get_name().toupper(), {"Driver did not find avalon_st_if in the environment: ", this.get_full_name(), ".vif"});
        end
    endfunction

    /*------------------------------------------------------------------------------
    -- Reset phase.
    ------------------------------------------------------------------------------*/
    virtual task reset_phase (uvm_phase phase);
        super.reset_phase(phase);

        // Resets the interface.
        if (this.configuration.is_master == MASTER) begin
            this.vif.CLEAR_MASTER_CB();
        end

        if (this.configuration.is_master == SLAVE) begin
            this.vif.CLEAR_SLAVE_CB();
        end

    endtask

    /*------------------------------------------------------------------------------
    -- Run Phase.
    ------------------------------------------------------------------------------*/
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
		
        // Run the driver task.
        fork
            if (this.configuration.is_master == MASTER) begin
                this.master_driver();
            end

            if (this.configuration.is_master == SLAVE) begin
                this.slave_driver();
            end

            /*------------------------------------------------------------------------------
            -- Clock Alignment.
            ------------------------------------------------------------------------------*/
            forever begin
                @ (this.vif.master_cb);
                -> this.posedge_clk;
            end

        join_none
    endtask

    // Driver Methods.
    /*------------------------------------------------------------------------------
    -- Master Driver.
    ------------------------------------------------------------------------------*/
    virtual task master_driver();
		
		bit [DATA_WIDTH_IN_BYTES*8 - 1:0]           						data_in_words[$];// a queue of data words to drive in the vif
		bit [generic_func_pack::log2up_func(DATA_WIDTH_IN_BYTES) - 1:0] 	empty;			// a 'empty' signal to drive in the vif 	
		bit                                           						valid;			// a 'valid' signal to drive in the vif
		bit                                           						sop;			// a 'sop' signal to drive in the vif
		bit                                           						eop;			// a 'eop' signal to drive in the vif
		
      	// wait one clock cycle for the clocking block reset to kick in
		@ (this.vif.master_cb);
      
		forever begin
			seq_item_port.get_next_item(req); 
			
			// get data from sequencer. cast from queue of byte to queue of words
			data_in_words = {>>{req.data_in_bytes}};

          `uvm_info(this.get_name().toupper(), $psprintf("New packet of size %1d bytes, %1d words", req.data_in_bytes.size(), data_in_words.size()), UVM_HIGH)
          
			// drive each word in the data item seperately
			foreach(data_in_words[i]) begin : words_loop
				              
				// sop = 1 in the first word only. eop = 1 in the last word only
				sop = (i == 0);
				eop = (i == data_in_words.size() - 1);
				
				// if we are on the last packet, calculate the empty value in bytes. otherwise empty = 0
				if (eop == 1) begin : empty_calc
                  empty = data_in_words.size()*DATA_WIDTH_IN_BYTES - req.data_in_bytes.size();
				end else begin
					empty = 0;
				end	// empty_calc
              
              
				this.vif.master_cb.data 	<= data_in_words[i];
				this.vif.master_cb.sop 		<= sop;
				this.vif.master_cb.eop 		<= eop;
				this.vif.master_cb.empty 	<= empty;
              
              
				// continue driving the signal until valid and ready are both 1 
              	do begin
                  
					// randomize valid
					std::randomize(valid) 	with{	
												valid dist{
															1 := this.configuration.valid_p,
															0 := 100 - this.configuration.valid_p
														};
											};
					// drive the valid signal
                  	
                  	
					this.vif.master_cb.valid <= valid;
                  	
                  	// wait for clock
					//wait(this.posedge_clk.triggered);
                	@ (this.vif.master_cb);
                  	
                  `uvm_info(this.get_name().toupper(), $psprintf("Driving word %d: %h, valid: %d, ready: %d, SOP: %d, EOP: %d", i + 1, data_in_words[i], valid, this.vif.master_cb.rdy, sop, eop), UVM_FULL)
                  
                  
                end while ((valid !== 1) || (this.vif.master_cb.rdy !== 1));
              
			end	// words_loop
			
			seq_item_port.item_done();

		end // forever
	
    endtask	// master_driver

    /*------------------------------------------------------------------------------
    -- Slave Driver.
    ------------------------------------------------------------------------------*/
    virtual task slave_driver();
	
		bit rdy;	// a 'rdy' signal to drive in the vif
		
      	// wait one clock cycle for the clocking block reset to kick in
		@ (this.vif.master_cb);
      
		forever begin
				
			// randomize ready
			std::randomize(rdy) with{	
										rdy dist{
													1 := this.configuration.rdy_p,
													0 := 100 - this.configuration.rdy_p
												};
									};
			
			// drive the ready signal in the virtual interface
			this.vif.slave_cb.rdy <= rdy;
          
			// wait for clock
			//wait(this.posedge_clk.triggered);
          	@ (this.vif.slave_cb);
          
            `uvm_info(this.get_name().toupper(), $psprintf("Driving ready: %d", rdy), UVM_FULL)

          
		end	// forever
	
    endtask	// slave_driver

endclass

`endif // __AVALON_ST_DRIVER