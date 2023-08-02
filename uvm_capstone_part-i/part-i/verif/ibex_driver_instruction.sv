`include "dv_macros.svh"
`define DRV_if instruction_vif.ins_driver_ports.ins_driver_clocking_block
`define drv instruction_vif.async_ports

class ibex_driver_instruction extends uvm_driver #(ibex_seq_item_instruction);

        `uvm_component_utils(ibex_driver_instruction)

        virtual interface ibex_instruction_mem_if instruction_vif;
        ibex_seq_item_instruction seq_ins;

        function new(string name = "ibex_driver_instruction", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                seq_ins = ibex_seq_item_instruction::type_id::create("seq_ins",this);

                    if (!uvm_config_db#(virtual ibex_instruction_mem_if)::get(this,"","instruction_mem_if", instruction_vif)) begin
                        `uvm_error("NO-VIF","uvm_config_db::get failed")
                end
                else begin
                  `uvm_info(`gtn,"VIF set in DRIVER successfully!",UVM_LOW)
                end

        endfunction : build_phase

        task run_phase(uvm_phase phase);
                super.run_phase(phase);
        `uvm_info(`gtn,"RUN phase of Driver",UVM_HIGH)
        instruction_vif.reset();
        wait(`drv.instr_req_o);
                `drv.instr_gnt_i    =   1'b1;
                repeat (1) @(`DRV_if);
                fork
                        begin
                                forever begin

                                        seq_item_port.get_next_item(seq_ins);
                                        `DRV_if.instr_rdata_i   <=      seq_ins.instr_rdata_i;
                                        `DRV_if.instr_rvalid_i  <=      1'b1;
                                        seq_item_port.item_done();
                                end
                        end
                        begin
                                forever begin
                                        @(negedge `drv.instr_req_o)
                                        `uvm_info(`gtn,"instr_req_o was low, therefore setting grant low as well",UVM_HIGH)
                                        `drv.instr_gnt_i        =       1'b0;
                                        @(instruction_vif.clk)
                                        `DRV_if.instr_rvalid_i  <=      1'b0;
                                        @(posedge `drv.instr_req_o);
                                        `drv.instr_gnt_i        =       1'b1;
                                        repeat (1) @(`DRV_if);
                                end
                        end
                join
        endtask : run_phase


endclass:ibex_driver_instruction



