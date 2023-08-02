class ibex_seq_item_instruction extends uvm_sequence_item;

        logic instr_req_o;
        logic instr_gnt_i;
        logic instr_rvalid_i;
        logic [31:0] instr_addr_o = 32'h80000080;
        logic [31:0] instr_rdata_i;
        logic instr_err_i;


        `uvm_object_utils_begin(ibex_seq_item_instruction)
                `uvm_field_int(instr_req_o, UVM_DEFAULT)
                `uvm_field_int(instr_gnt_i, UVM_DEFAULT)
                `uvm_field_int(instr_rvalid_i, UVM_DEFAULT)
                `uvm_field_int(instr_addr_o, UVM_DEFAULT)
                `uvm_field_int(instr_rdata_i, UVM_DEFAULT)
                `uvm_field_int(instr_err_i, UVM_DEFAULT)
        `uvm_object_utils_end

    function new(string name = "ibex_seq_item_instruction");
        super.new(name);
        endfunction : new

endclass

