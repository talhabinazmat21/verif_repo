`include "dv_macros.svh"
`define MON_if instruction_vif.ins_monitor_ports.ins_monitor_clocking_block

class ibex_monitor_instruction extends uvm_monitor;

        `uvm_component_utils(ibex_monitor_instruction)

        virtual interface ibex_instruction_mem_if instruction_vif;
        ibex_seq_item_instruction seq_ins;
        uvm_analysis_port#(ibex_seq_item_instruction) mem_req_fifo_ins;

        function new(string name = "ibex_monitor_instruction", uvm_component parent = null);
                super.new(name, parent);
                mem_req_fifo_ins = new("mem_req_fifo_ins", this);
        endfunction : new

                function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                 if (!uvm_config_db#(virtual ibex_instruction_mem_if)::get(this,"","instruction_mem_if", instruction_vif)) begin
                        `uvm_error("NO-VIF","uvm_config_db::get failed")
                end
                else begin
                    `uvm_info(`gtn,"VIF set in MONITOR successfully!",UVM_LOW)
                end

        endfunction : build_phase
        
        task run_phase(uvm_phase phase);
                super.run_phase(phase);

                forever begin
                        seq_ins = ibex_seq_item_instruction::type_id::create("seq_ins");
                        @(`MON_if);
                        if (`MON_if.instr_req_o) begin
                                seq_ins.instr_req_o             =       `MON_if.instr_req_o;
                                seq_ins.instr_gnt_i             =       `MON_if.instr_gnt_i;
                                seq_ins.instr_rvalid_i  =       `MON_if.instr_rvalid_i;
                                seq_ins.instr_addr_o    =       `MON_if.instr_addr_o;
                                seq_ins.instr_rdata_i   =       `MON_if.instr_rdata_i;
                                seq_ins.instr_err_i             =       `MON_if.instr_err_i;
                                `uvm_info(`gtn,$sformatf("MONITOR: Instructions Collected :\n%s", seq_ins.sprint()),UVM_LOW)
                                mem_req_fifo_ins.write(seq_ins);
                        end
                end
        endtask : run_phase

endclass: ibex_monitor_instruction


