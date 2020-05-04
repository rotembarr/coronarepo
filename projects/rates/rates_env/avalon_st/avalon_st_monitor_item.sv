
`ifndef __AVALON_ST_MONITOR_ITEM
`define __AVALON_ST_MONITOR_ITEM

class avalon_st_monitor_item #(
    parameter int unsigned DATA_WIDTH_IN_BYTES = 4
) extends uvm_object;
    /*------------------------------------------------------------------------------
    -- Data Members.
    ------------------------------------------------------------------------------*/
    byte data_in_bytes[$]   = {};


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

        // Initialize data members.
        this.data_in_bytes      = {};
    endfunction

    /*-------------------------------------------------------------------------------
    -- Do Pack.
    -------------------------------------------------------------------------------*/
    virtual function void do_pack (uvm_packer packer = null);
        super.do_pack(packer);

        // if packer was not set than set as default packer.
        if (packer == null) begin
            packer = uvm_default_packer;
        end

        // Pack the data.
        for (int i = 0; i < this.data_in_bytes.size() ; i++) begin
            packer.pack_field_int(this.data_in_bytes[i], $bits(byte));
        end
    endfunction

    /*-------------------------------------------------------------------------------
    -- Do Unpack.
    -------------------------------------------------------------------------------*/
    virtual function void do_unpack (uvm_packer packer = null);
        // Variables.
        int unsigned payload_size = 0;
        int unsigned data_size_in_bytes = 0;

        // Super method.
        super.do_unpack(packer);

        // Gets the defualt packer.
        if (packer == null) begin
            packer = uvm_default_packer;
        end

        // Get packed data size.
        payload_size = packer.get_packed_size() / $bits(byte);

        // Unpack the data.
        for (int i = 0; i < payload_size; i++) begin
            this.data_in_bytes[i] = packer.unpack_field($bits(byte));
        end
    endfunction

    /*-------------------------------------------------------------------------------
    -- Do Compare.
    -------------------------------------------------------------------------------*/
    virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
        // RHS Item.
        avalon_st_monitor_item #(DATA_WIDTH_IN_BYTES) avalon_st_rhs = null;

        do_compare = super.do_compare(rhs, comparer);

        $cast(avalon_st_rhs, rhs);

        if (this.data_in_bytes != avalon_st_rhs.data_in_bytes) begin
            $write("ENV DATA");
            repeat (DATA_WIDTH_IN_BYTES) begin
                $write("    ");
            end
            $write("      ");
            $display("DUT DATA");
            this.print_queues(this.data_in_bytes, avalon_st_rhs.data_in_bytes);
        end
    endfunction

    /*------------------------------------------------------------------------------
    -- Print Queues.
    ------------------------------------------------------------------------------*/
  function void print_queues (byte q_1[$], byte q_2[$]);
        // Variables.
        int unsigned size_to_print = 0;
        int unsigned i             = 0;

        if (q_2.size() > q_1.size()) size_to_print = q_2.size(); else size_to_print = q_1.size();

        while (i < size_to_print) begin

            // Print one word from environment.
            this.print_word_by_index(q_1, i);

            // Make some space.
            $write("              ");

            // Print one word from DUT.
            this.print_word_by_index(q_2, i);

            // DATA_WIDTH_IN_BYTES bytes were printed.
            i+= DATA_WIDTH_IN_BYTES;

            // Move to the next word.
            $display();
        end
    endfunction

    /*------------------------------------------------------------------------------
    -- Print Word By Index.
    ------------------------------------------------------------------------------*/
  function void print_word_by_index (byte queue[$], int unsigned start_index);
        for (int i = 0; i < DATA_WIDTH_IN_BYTES; i++) begin
            if (start_index + i < queue.size()) begin
                $write("%2x, ", queue[start_index + i]);
            end else begin
                $write("    ");
            end
        end
    endfunction
endclass

`endif // __AVALON_ST_MONITOR_ITEM