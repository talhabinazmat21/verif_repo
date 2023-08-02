`include "dv_macros.svh"
//`include "mem_model.sv"
class ibex_sequence_load_store extends uvm_sequence #(ibex_seq_item_load_store);

        ibex_seq_item_load_store seq_data;
        mem_model mem;

        logic [31:0] mem_addr;
        logic [31:0] mem_read_data;
        logic [31:0] mem_write_data;
        logic data_we;

        `uvm_object_utils(ibex_sequence_load_store)

        `uvm_declare_p_sequencer(ibex_sequencer_load_store)

        function new(string name = "ibex_sequence_load_store");
      super.new(name);
      mem = mem_model#()::type_id::create("mem");
    endfunction : new

    virtual task pre_body();
        $display("MEMORY INSTRUCTIONS");
        foreach (mem.system_memory[i]) begin
                $display("Address = %0h, Instruction = %0h",i,mem.system_memory[i]);
        end
        endtask : pre_body

    virtual task body();

                forever begin
                seq_data = ibex_seq_item_load_store::type_id::create("seq_data");
                        `uvm_info(`gtn, "Before getting data from LSU p_sequencer",UVM_HIGH)
                        p_sequencer.mem_request_fifo_lsu.get(seq_data); // data received from monitor (via p_sequencer)
                        `uvm_info(`gtn, "After getting data from LSU p_sequencer",UVM_HIGH)
                        mem_addr        = seq_data.data_addr_o;         // Address of instruction
                        mem_write_data  = seq_data.data_wdata_o;        // Write Data operatoin
                        data_we         = seq_data.data_we_o;           // Write Operation or Read Operation bit
                        `uvm_info(`gtn, "Request noted, now decode the request",UVM_HIGH)
                        `uvm_info(`gtn,$sformatf("SEQUENCE: Packet Collected by Sequence class of LSU Agent:\n%s", seq_data.sprint()),UVM_LOW)
                        start_item(seq_data);
                        
                         if(!data_we) begin // When Read Operation is executed(data_we = 0)
                                `uvm_info(`gtn, "READ REQUEST",UVM_LOW)
                                mem_read_data = mem.read(mem_addr); // Data Read Operation
                                `uvm_info(`gtn, $sformatf("DATA READ %d",mem_read_data), UVM_FULL)
                                seq_data.data_gnt_i = 1'b1;
                                seq_data.data_rdata_i = mem_read_data;
                                seq_data.data_rvalid_i = 1'b1;
                                seq_data.data_err_i = 1'b0;
                        end

                        if(data_we) begin // When Write Operation is executed(data_we = 1)
                                `uvm_info(`gtn, "WRITE REQUEST",UVM_HIGH)
                                mem.write(mem_addr,mem_write_data); // Data Write Operation
                                `uvm_info(`gtn, $sformatf("DATA WRITE %d at Address %d",mem_write_data,mem_addr), UVM_FULL)
                                seq_data.data_gnt_i = 1'b1;
                                seq_data.data_rvalid_i = 1'b1;
                                seq_data.data_err_i = 1'b0;
                        end
                        `uvm_info(`gtn, "DATA prepared in Load Store Unit Sequence class",UVM_HIGH)
                        finish_item(seq_data);
                        `uvm_info(`gtn,$sformatf("Load Store Unit Sequence class: DATA Sent :\n%s", seq_data.sprint()),UVM_LOW)
                end
    endtask : body

endclass:ibex_sequence_load_store


