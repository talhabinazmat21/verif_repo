`include "dv_macros.svh"
//`include "mem_model.sv"

class ibex_base_test extends uvm_test;

        `uvm_component_utils(ibex_base_test)

        ibex_environment_instruction env;
        ibex_sequence_instruction seq_ins;
        ibex_sequence_load_store seq_data;

        mem_model mem;

        virtual ibex_dut_probe_if dut_probe_if;

        function new(string name = "ibex_base_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction : new

        virtual function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                env = ibex_environment_instruction::type_id::create("env", this);
                mem = mem_model#()::type_id::create("mem");
                seq_ins = ibex_sequence_instruction::type_id::create("seq_ins");
                seq_data = ibex_sequence_load_store::type_id::create("seq_data");
                // Setting memory to fetch and lsu sequence object classes              
                seq_ins.mem = mem;
                seq_data.mem = mem;
                 if (!uvm_config_db#(virtual ibex_dut_probe_if)::get(this,"","dut_probe_if", dut_probe_if)) begin
                        `uvm_error("NO-VIF","uvm_config_db::get failed")
                end
                else begin
                    `uvm_info(`gfn,"VIF set in TEST successfully!",UVM_LOW)
                end

    endfunction : build_phase
    
 task run_phase(uvm_phase phase);
                super.run_phase(phase);

                phase.raise_objection(this);
                dut_probe_if.dut_probe_ports.fetch_enable = 1'b0; // Initially setting fetch enable low
                @(posedge dut_probe_if.clk);
                  $display("starting loading bin file");
                  load_binary_to_mem();

                dut_probe_if.dut_probe_ports.fetch_enable = 1'b1; // Setting fetch enable high
                mem.print_written_bytes();
                fork
                        begin
                                seq_ins.start(env.agt_ins.ins_seqr);
                        end
                        begin
                                seq_data.start(env.agt_data.seqr_lsu);
                        end
                        begin
                                `uvm_info(`gtn, "Waiting for ECALL signal to get high",UVM_HIGH)
                                @(dut_probe_if.ecall);
                                `uvm_info(`gfn, "ECALL signal received, deasserting the fetch_enable",UVM_HIGH)
                                #50 dut_probe_if.dut_probe_ports.fetch_enable = 1'b0;
                                `uvm_info(`gfn, "Test ends here!",UVM_HIGH)
                        end
                join_any
                disable fork;
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this,2000us);

        endtask
        
        function void load_binary_to_mem();
                string      bin;
                bit [7:0]   rb;
                bit [31:0]  addr = 32'h80000080; //     Boot address
                int         f_bin;

                bin = "test.bin";
                f_bin = $fopen(bin,"rb");
                if (!f_bin)
                         `uvm_fatal(`gfn, $sformatf("Cannot open file %0s", bin))
                while ($fread(rb,f_bin)) begin
                  `uvm_info(`gfn, $sformatf("Init mem [0x%h] = 0x%0h", addr, rb), UVM_FULL)
                  mem.write_byte(addr, rb);
                  addr++;
                end
        endfunction : load_binary_to_mem

endclass : ibex_base_test
                          

