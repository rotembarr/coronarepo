
`ifndef __AVALON_ST_MONITOR
`define __AVALON_ST_MONITOR

class avalon_st_monitor #(
    parameter int unsigned DATA_WIDTH_IN_BYTES = 4
) extends uvm_monitor;
    /*-------------------------------------------------------------------------------
    -- UVM Macros - Factory register.
    -------------------------------------------------------------------------------*/
    // Provides implementations of virtual methods such as get_name and create.
    `uvm_component_param_utils(avalon_st_monitor #(DATA_WIDTH_IN_BYTES))

    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    // Virtual interface.
    virtual avalon_st_if #(DATA_WIDTH_IN_BYTES) vif = null;

    // Agent configuration.
    avalon_st_configuration configuration = null;

    // Analysis port for output items.
    uvm_analysis_port #(avalon_st_monitor_item #(DATA_WIDTH_IN_BYTES)) data_export  = null;

    // Output item declaration.
    avalon_st_monitor_item #(DATA_WIDTH_IN_BYTES) data_item  = null;

    /*------------------------------------------------------------------------------
    -- Tasks & Functions declarations.
    ------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
    -- Constructor.
    ------------------------------------------------------------------------------*/
    function new (string name = "avalon_st_monitor", uvm_component parent = null);
        super.new(name, parent);

        // Initialize data members.
        this.vif           = null;
        this.configuration = null;
        this.data_export   = null;
      	this.data_item     = avalon_st_monitor_item #(DATA_WIDTH_IN_BYTES)::type_id::create ("data_item", this);
    endfunction

    /*------------------------------------------------------------------------------
    -- Build Phase.
    ------------------------------------------------------------------------------*/
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Connect the configuration to the driver.
        if (!uvm_config_db #(avalon_st_configuration)::get(this, "", "configuration", this.configuration)) begin
            `uvm_fatal(this.get_name().toupper(), {"Monitor did not find avalon_st_configuration in the environment: ", this.get_full_name(), ".configuration"});
        end

        // Connect the monitor to the interface.
        if (!uvm_config_db #(virtual avalon_st_if #(DATA_WIDTH_IN_BYTES))::get(this, "", "vif", this.vif)) begin
            `uvm_fatal(this.get_name().toupper(), {"Monitor did not find avalon_st_if in the environment: ", this.get_full_name(), ".vif"});
        end

        // Create the analysis ports.
        this.data_export  = new("data_export",  this);
    endfunction

    /*------------------------------------------------------------------------------
    -- Run Phase.
    ------------------------------------------------------------------------------*/
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        // Run the monitor task.
        fork
            this.monitor_task();
        join_none
    endtask

    // Methods.
    /*------------------------------------------------------------------------------
    -- Monitor Task.
    ------------------------------------------------------------------------------*/
    virtual task monitor_task ();
        // TODO - write you code
      bit [DATA_WIDTH_IN_BYTES*8 - 1:0]	data_in_words[$] = {};// a queue of data words to get from the vif
      
		forever begin
          	
            
          
          	// we wait until ready and valid are 1
          	if((this.vif.monitor_cb.rdy === 1) && (this.vif.monitor_cb.valid === 1)) begin
              	
                // if sop is 1 we start a new packet and reset the queue
                if (this.vif.monitor_cb.sop == 1) begin
                    data_in_words = {};
                end
              	
              	// insert the new data word to the queue
              	data_in_words = {data_in_words, this.vif.monitor_cb.data};
				
              	`uvm_info(this.get_name().toupper(), $psprintf("Fetching word: %h", this.vif.monitor_cb.data), UVM_FULL)	
              
             	// if eop is 1 then we finishes the packet and export it out
              	if (this.vif.monitor_cb.eop == 1) begin
                	
                	// cast the words queue to bytes queue
                	this.data_item.data_in_bytes = {>>{data_in_words}};
                
                	// remove the empty bytes in the last word
                	this.data_item.data_in_bytes = this.data_item.data_in_bytes[0:$-this.vif.monitor_cb.empty];
                	
                  `uvm_info(this.get_name().toupper(), $psprintf("Got packet of size %1d bytes, %1d words", this.data_item.data_in_bytes.size(), data_in_words.size()), UVM_HIGH)
                
                	// export item
                    this.data_export.write(this.data_item);
               	end // eop == 1
              
			end	//rdy & valid == 1
          
          	// wait for clock
			@ (this.vif.monitor_cb);
          
		end	// forever
		
    endtask

endclass

`endif // __AVALON_ST_MONITOR