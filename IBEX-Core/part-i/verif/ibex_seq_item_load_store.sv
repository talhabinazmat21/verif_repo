class ibex_seq_item_load_store extends uvm_sequence_item;

        logic data_req_o;
        logic data_gnt_i;
        logic data_rvalid_i;
        logic data_we_o;
        logic [3:0 ]    data_be_o;
        logic [31:0]    data_addr_o;
        logic [31:0]    data_wdata_o;
        logic [31:0]    data_rdata_i;
        logic data_err_i;

        `uvm_object_utils_begin(ibex_seq_item_load_store)
                `uvm_field_int(data_req_o, UVM_DEFAULT)
                `uvm_field_int(data_gnt_i, UVM_DEFAULT)
                `uvm_field_int(data_rvalid_i, UVM_DEFAULT)
                `uvm_field_int(data_we_o, UVM_DEFAULT)
                `uvm_field_int(data_be_o, UVM_DEFAULT)
                `uvm_field_int(data_addr_o, UVM_DEFAULT)
                `uvm_field_int(data_wdata_o, UVM_DEFAULT)
                `uvm_field_int(data_rdata_i, UVM_DEFAULT)
                `uvm_field_int(data_err_i, UVM_DEFAULT)
        `uvm_object_utils_end


    function new(string name = "ibex_seq_item_load_store");
        super.new(name);
        endfunction : new

endclass : ibex_seq_item_load_store

