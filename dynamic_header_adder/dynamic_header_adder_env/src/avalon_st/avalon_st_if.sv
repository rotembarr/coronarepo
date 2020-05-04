
// Avalon ST interface.
`ifndef __AVALON_ST_IF
`define __AVALON_ST_IF


interface avalon_st_if #(parameter int DATA_WIDTH_IN_BYTES = 4) (input clk);

    logic   [DATA_WIDTH_IN_BYTES*8 - 1:0]           data;
    logic   [generic_func_pack::log2up_func(DATA_WIDTH_IN_BYTES) -1:0] 		empty;
    logic                                           valid;
    logic                                           sop;
    logic                                           eop;
    logic                                           rdy;


   task CLEAR_MASTER() ;
        valid               <= '0;
        sop                 <= '0;
        eop                 <= '0;
        data                <= '0;
        empty               <= '0;
    endtask
    
    task CLEAR_MASTER_COMB() ;
        valid               = '0;
        sop                 = '0;
        eop                 = '0;
        data                = '0;
        empty               = '0;
    endtask

// synthesis translate_off
   task CLEAR_MASTER_CB() ;
       master_cb.valid              <= '0;
       master_cb.sop                <= '0;
       master_cb.eop                <= '0;
       master_cb.data               <= '0;
       master_cb.empty              <= '0;
    endtask

    task CLEAR_SLAVE_CB();
        slave_cb.rdy <= 1'b1;
    endtask

// synthesis translate_on

    task CLEAR_SLAVE() ;
        rdy <= 1;
    endtask
    
    task CLEAR_SLAVE_COMB() ;
        rdy = 1;
    endtask
// synthesis translate_off
     clocking master_cb @(posedge clk);
        default input #1;

        output       data;
        output       empty;
        output       valid;
        output       sop;
        output       eop;
        input        rdy;
    endclocking

    clocking slave_cb @(posedge clk);
        input      data;
        input      empty;
        input      valid;
        input      sop;
        input      eop;
        output     rdy;
    endclocking

    clocking monitor_cb @(posedge clk);
        input      data;
        input      empty;
        input      valid;
        input      sop;
        input      eop;
        input      rdy;
    endclocking
// synthesis translate_on

    modport slave(input         data,
                  input         empty,
                  input         valid,
                  input         sop,
                  input         eop,
                  output        rdy,
                  import        CLEAR_SLAVE,
                  import        CLEAR_SLAVE_COMB
                 );

    modport master( output       data,
                    output       empty,
                    output       valid,
                    output       sop,
                    output       eop,
                    input        rdy,
                    import       CLEAR_MASTER,
                    import       CLEAR_MASTER_COMB
              );

    modport monitor(input        data,
                    input        empty,
                    input        valid,
                    input        sop,
                    input        eop,
                    input        rdy
              );

endinterface

`endif // __AVALON_ST_IF
