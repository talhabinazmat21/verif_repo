//      Data Memory Interface for Load_Store Unit to read and write in memory 

interface ibex_data_mem_if(input logic clk);
    logic                         data_req_o;
    logic                         data_gnt_i;
    logic                         data_rvalid_i;
    logic                         data_we_o;
    logic [3:0]                   data_be_o;
    logic [31:0]                  data_addr_o;
    logic [31:0]                  data_wdata_o;
    logic [31:0]                  data_rdata_i;
    logic                         data_err_i;

    clocking lsu_driver_clocking_block @(posedge clk);
        default input #1 output #1;
                        input data_req_o;
                        input data_we_o;
                        input data_be_o;
                        input data_addr_o;
                        input data_wdata_o;
                        output data_gnt_i;
                        output data_rvalid_i;
                        output data_rdata_i;
                        output data_err_i;
    endclocking : lsu_driver_clocking_block

    clocking lsu_monitor_clocking_block @(posedge clk);
        default input #1 output #1;
                        input data_req_o;
                        input data_we_o;
                        input data_be_o;
                        input data_addr_o;
                        input data_wdata_o;
                        input data_gnt_i;
                        input data_rvalid_i;
                        input data_rdata_i;
                        input data_err_i;
    endclocking : lsu_monitor_clocking_block

        modport lsu_driver_ports(clocking lsu_driver_clocking_block, input clk);
        modport lsu_monitor_ports(clocking lsu_monitor_clocking_block, input clk);

 modport async_ports(input data_req_o, output data_gnt_i);

        task automatic wait_pos_clks(input int num);
        repeat (num) @(posedge clk);
        endtask

        task automatic wait_neg_clks(input int num);
        repeat (num) @(negedge clk);
        endtask

        task automatic reset();
                data_req_o              <=      1'b0;
                data_gnt_i              <=      1'b0;
                data_rvalid_i           <=      1'b0;
                data_we_o               <=      1'b0;
                data_be_o               <=      1'b0;
                data_addr_o             <=      1'b0;
                data_wdata_o            <=      1'b0;
                data_rdata_i            <=      1'b0;
                data_err_i              <=      1'b0;
        endtask

endinterface : ibex_data_mem_if

