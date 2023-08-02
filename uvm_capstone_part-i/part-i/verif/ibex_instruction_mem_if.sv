interface ibex_instruction_mem_if(input logic clk,input logic rst_n);

        import uvm_pkg::*;
        `include "uvm_macros.svh"

    logic                         instr_req_o;
    logic                         instr_gnt_i;
    logic                         instr_rvalid_i;
    logic [31:0]                  instr_addr_o;
    logic [31:0]                  instr_rdata_i;
    logic                         instr_err_i;

    clocking ins_driver_clocking_block @(posedge clk);
        default input #1 output #1;
                input instr_req_o;
                input instr_addr_o;
                output instr_gnt_i;
                output instr_rvalid_i;
                output instr_rdata_i;
                output instr_err_i;
    endclocking : ins_driver_clocking_block

    clocking ins_monitor_clocking_block @(posedge clk);
        default input #1 output #1;
                input instr_req_o;
                input instr_addr_o;
                input instr_gnt_i;
                input instr_rvalid_i;
                input instr_rdata_i;
                input instr_err_i;
    endclocking : ins_monitor_clocking_block

        modport ins_driver_ports(clocking ins_driver_clocking_block, input clk);
        modport ins_monitor_ports(clocking ins_monitor_clocking_block, input clk);
    modport async_ports(input instr_req_o,output instr_gnt_i);
    
     task automatic wait_pos_clks(input int num);
        repeat (num) @(posedge clk);
        endtask : wait_pos_clks

        task automatic wait_neg_clks(input int num);
        repeat (num) @(negedge clk);
        endtask : wait_neg_clks

        task automatic reset();
                instr_req_o             <=      1'b0;
                instr_addr_o            <=      'b0;
                instr_gnt_i             <=      1'b0;
                instr_rvalid_i          <=      1'b0;
                instr_rdata_i           <=      'b0;
                instr_err_i             <=      1'b0;
          endtask : reset

endinterface : ibex_instruction_mem_if


