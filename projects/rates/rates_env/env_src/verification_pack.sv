
`ifndef __verification_pack
`define __verification_pack

package verification_pack;
    /*------------------------------------------------------------------------------
    -- Simulation parameter.
    ------------------------------------------------------------------------------*/
    time                    CLK_CYCLE_TIME   = 5ns;
    time                    TIMEOUT          = 10ms;
    bit                     TOPOLOGY         = 1'b1;
    bit                     INFINITE         = 1'b0;
    localparam int unsigned MAX_MESSAGES     = 10000;

    /*------------------------------------------------------------------------------
    -- Interfaces & module instantion generics.
    ------------------------------------------------------------------------------*/
    `ifndef DATA_WIDTH_IN_BYTES
        `define DATA_WIDTH_IN_BYTES 16
    `endif
    /*------------------------------------------------------------------------------
    -- Interfaces parameters.
    ------------------------------------------------------------------------------*/
    localparam int unsigned DATA_WIDTH_IN_BYTES = `DATA_WIDTH_IN_BYTES;
    localparam int unsigned dest_rate_in_Gbps   = 5;


endpackage

`endif // __verification_pack
