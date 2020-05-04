import uvm_pkg::*;


// define master slave enum
typedef enum {MASTER, SLAVE} verification_master_slave_enum; 

package generic_func_pack;

    

    //////////////////////////
    //      Log 2 UP.       //
    //////////////////////////
    // In : the function receivs an integer.
    // Out : returns the power that has to be applied to 2
    // 		 in order to recieve the input num or pass it.
    //  USE FOR CONSTANTS CALCULATION ONLY.
    function int log2up_func (input int num);

        //  1 or 0 are an exception, since they require 1 bit, but their log2up_func is 0.
        if (num == 1 | num == 0) begin
            return 1;
        end

        for (int i = 0 ; i <= num ; i++) begin
            if (2**i >= num) begin
                return i;
            end
        end
    endfunction
endpackage
