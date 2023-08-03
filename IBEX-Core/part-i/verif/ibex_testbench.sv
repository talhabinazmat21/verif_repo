module ibex_tb;

           // import the UVM library
           import uvm_pkg::*;

           // include the UVM macros
          `include "uvm_macros.svh"
        //import all packages
          import bus_params_pkg::*;
          import mem_model_pkg::*;
          import riscv_signature_pkg::*;

          //Include all instruction memory unit files
        `include "ibex_seq_item_instruction.sv"
         `include "ibex_sequencer_instruction.sv"
        `include "ibex_sequence_instruction.sv"
        `include "ibex_driver_instruction.sv"
        `include "ibex_monitor_instruction.sv"
        `include "ibex_agent_instruction.sv"

        //include all data memory unit files
        `include "ibex_seq_item_load_store.sv"
        `include "ibex_sequencer_load_store.sv"
        `include "ibex_sequence_load_store.sv"
        `include "ibex_driver_load_store.sv"
        `include "ibex_monitor_load_store.sv"
        `include "ibex_agent_load_store.sv"
        //iclude environment and test files
        `include "ibex_environment_instruction.sv"
        `include "ibex_base_test.sv"
        
         // Initial begin logic. Start the System with reset state.
        logic clk = 0;
        logic rst_n;

        initial begin
        clk <= 0;
                rst_n <= 1;
                @(posedge clk);
                        rst_n <= 0;
                @(posedge clk);
                        rst_n <= 1;
        end

        // Clock initialization 
        always begin
      #5 clk = ~clk;
    end

        // Parameter Macros
        `ifndef IBEX_CFG_RegFile
        `define IBEX_CFG_RegFile ibex_pkg::RegFileFF
        `endif

        `ifndef IBEX_CFG_RV32B
        `define IBEX_CFG_RV32B ibex_pkg::RV32BNone
        `endif

        `ifndef IBEX_CFG_RV32M
        `define IBEX_CFG_RV32M ibex_pkg::RV32MFast
        `endif
        
         // Defining parameters
        parameter bit              PMPEnable = 1'b0;
        parameter int unsigned PMPGranularity = 0;
        parameter int unsigned PMPNumRegions  = 4;
        parameter bit RV32E = 1'b0;
        parameter ibex_pkg::rv32m_e RV32M = `IBEX_CFG_RV32M;
        parameter ibex_pkg::rv32b_e RV32B = `IBEX_CFG_RV32B;
        parameter ibex_pkg::regfile_e RegFile = `IBEX_CFG_RegFile;
        parameter bit BranchTargetALU = 1'b0;
        parameter bit WritebackStage = 1'b0;
        parameter bit ICache = 0;
        parameter bit ICacheECC = 0;
        parameter bit BranchPredictor = 1'b0;
        parameter bit DbgTriggerEn = 1'b0;
        parameter bit SecureIbex = 1'b0;
        parameter bit DmHaltAddr = 1'b0;

        // Interface Instances 
        ibex_dut_probe_if dut_probe_if(.clk(clk));
        ibex_instruction_mem_if instruction_vif(.clk(clk), .rst_n(rst_n));
        ibex_data_mem_if  data_mem_if(.clk(clk));

        // Passing the parameters to DUT 
        // Instantiating DUT
        ibex_top_tracing
        #(
                .PMPEnable         (PMPEnable       ),
                .PMPGranularity    (PMPGranularity  ),
                .PMPNumRegions     (PMPNumRegions   ),
                .RV32E             (RV32E           ),
                .RV32M             (RV32M           ),
                .RV32B             (RV32B           ),
                .RegFile           (RegFile         ),
                .BranchTargetALU   (BranchTargetALU ),
                .WritebackStage    (WritebackStage  ),
                .ICache            (ICache          ),
                .ICacheECC         (ICacheECC       ),
                .BranchPredictor   (BranchPredictor ),
                .DbgTriggerEn      (DbgTriggerEn    ),
                .SecureIbex        (SecureIbex      ),
                .DmHaltAddr        (DmHaltAddr      )
                )
                
    dut(
        .clk_i          (instruction_vif.clk),
        .rst_ni         (instruction_vif.rst_n),
        .test_en_i      (1'b0),
        .scan_rst_ni    (1'b1),
        .ram_cfg_i      ('b0),
        .hart_id_i      (32'b0),
        .boot_addr_i    (32'h80000080),
        // Instruction memory interface
        .instr_req_o    (instruction_vif.instr_req_o),
        .instr_gnt_i    (instruction_vif.instr_gnt_i),
        .instr_rvalid_i (instruction_vif.instr_rvalid_i),
        .instr_addr_o   (instruction_vif.instr_addr_o),
        .instr_rdata_i  (instruction_vif.instr_rdata_i),
        .instr_err_i    (instruction_vif.instr_err_i),
        // Data memory interface
        .data_req_o     (data_mem_if.data_req_o),
        .data_gnt_i     (data_mem_if.data_gnt_i),
        .data_rvalid_i  (data_mem_if.data_rvalid_i),
        .data_we_o      (data_mem_if.data_we_o),
        .data_be_o      (data_mem_if.data_be_o),
        .data_addr_o    (data_mem_if.data_addr_o),
        .data_wdata_o   (data_mem_if.data_wdata_o),
        .data_rdata_i   (data_mem_if.data_rdata_i),
        .data_err_i     (data_mem_if.data_err_i),
        // Interrupt inputs
        .irq_software_i     (0),
        .irq_timer_i        (0),
        .irq_external_i     (0),
        .irq_fast_i         (0),
        .irq_nm_i           (0),
        // Debug Interface
        .debug_req_i        (dut_probe_if.debug_req),
        .crash_dump_o       (0),
        // CPU Control Signals (Probe Interface)
        .fetch_enable_i     (dut_probe_if.fetch_enable),
        .alert_minor_o      (dut_probe_if.alert_minor),
        .alert_major_o      (dut_probe_if.alert_major),
        .core_sleep_o       (dut_probe_if.core_sleep)
        );
        
         initial begin
                // Configure interfaces with database
        uvm_config_db#(virtual ibex_instruction_mem_if)::set(null, "*", "instruction_mem_if", instruction_vif);
        uvm_config_db#(virtual ibex_data_mem_if)::set(null, "*", "data_mem_if", data_mem_if);
                uvm_config_db#(virtual ibex_dut_probe_if)::set(null, "*", "dut_probe_if", dut_probe_if);
        run_test("ibex_base_test");
    end

        // Check for ecall signal when handled by the core
        // Assigning it to probe interface ecall signal 
  assign dut_probe_if.ecall = dut.u_ibex_top.u_ibex_core.id_stage_i.controller_i.ecall_insn;

   initial begin
                $dumpfile("dump.vcd");
                $dumpvars(0,ibex_tb);
        end


endmodule : ibex_tb





