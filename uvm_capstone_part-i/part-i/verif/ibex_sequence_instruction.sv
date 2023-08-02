`include "dv_macros.svh"
//`include "mem_model.sv"
class ibex_sequence_instruction extends uvm_sequence #(ibex_seq_item_instruction);

        ibex_seq_item_instruction seq_ins;

        mem_model mem;

        logic [31:0] mem_addr;
        logic [31:0] mem_read_data;

        `uvm_object_utils(ibex_sequence_instruction)

        `uvm_declare_p_sequencer(ibex_sequencer_instruction)

        function new (string name="ibex_sequence_instruction");
      super.new(name);
      mem = mem_model#()::type_id::create("mem");
    endfunction : new

    virtual task pre_body();
        $display("MEMORY INSTRUCTIONS!");
        foreach (mem.system_memory[i]) begin
                $display("Wajahat Ali system_memory_size=%d",mem.system_memory.size());
                $display("Address = %0h, Instruction = %0h",i,mem.system_memory[i]);
        end
        endtask : pre_body

    virtual task body();
                if(mem ==  null) begin
                        `uvm_fatal(`gfn, "Cannot get memory model") end
                forever begin
                seq_ins = ibex_seq_item_instruction::type_id::create("seq-ins");
                        p_sequencer.mem_request_fifo_ins.get(seq_ins);
                        `uvm_info(`gtn,$sformatf("Instruction Address : %h",  seq_ins.instr_addr_o), UVM_HIGH)
                        start_item(seq_ins);
                        mem_addr = seq_ins.instr_addr_o;
                        mem_read_data = mem.read(mem_addr);
                        `uvm_info(`gtn, $sformatf("Serving request for mem = 0x%0h, with data = 0x%0h", mem_addr, mem_read_data), UVM_FULL)
                        seq_ins.instr_rdata_i = mem_read_data;
                        seq_ins.instr_gnt_i = 1'b1;
                        seq_ins.instr_rvalid_i = 1'b1;
                        seq_ins.instr_err_i = 1'b0;
                finish_item(seq_ins);
                 end
    endtask : body

endclass : ibex_sequence_instruction


