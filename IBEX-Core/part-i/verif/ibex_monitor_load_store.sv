`include "dv_macros.svh"
`define MON_vif data_mem_if.lsu_monitor_ports.lsu_monitor_clocking_block

class ibex_monitor_load_store extends uvm_monitor;

        `uvm_component_utils(ibex_monitor_load_store)

        ibex_seq_item_load_store seq_data;


        virtual interface ibex_data_mem_if data_mem_if;

        // Declaring analysis ports for data transfer 
        uvm_analysis_port#(ibex_seq_item_load_store) mem_req_fifo_lsu;

        function new(string name = "ibex_monitor_load_store", uvm_component parent = null);
                super.new(name, parent);
                mem_req_fifo_lsu = new("mem_req_fifo_lsu", this);
        endfunction : new

        function void build_phase(uvm_phase phase);
                seq_data = ibex_seq_item_load_store::type_id::create("seq_data",this);
                 if (!uvm_config_db#(virtual ibex_data_mem_if)::get(this,"","data_mem_if", data_mem_if)) begin
                         `uvm_error("NO_VIF","uvm_config_db::get failed")
                end
                else begin
                    `uvm_info(`gtn,"Vif set in Load Store UNit MONITOR successfully!",UVM_LOW)
                end

        endfunction : build_phase
        
         task run_phase(uvm_phase phase);
                super.run_phase(phase);

                forever begin
                        seq_data = ibex_seq_item_load_store::type_id::create("seq_data",this);
                        @(`MON_vif);
                        if (`MON_vif.data_req_o) begin
                                seq_data.data_req_o             =       `MON_vif.data_req_o;
                                seq_data.data_gnt_i             =       `MON_vif.data_gnt_i;
                                seq_data.data_rvalid_i          =       `MON_vif.data_rvalid_i;
                                seq_data.data_addr_o            =       `MON_vif.data_addr_o;
                                seq_data.data_rdata_i           =       `MON_vif.data_rdata_i;
                                seq_data.data_err_i             =       `MON_vif.data_err_i;
                                seq_data.data_we_o              =       `MON_vif.data_we_o;
                                seq_data.data_be_o              =       `MON_vif.data_be_o;
                                seq_data.data_wdata_o           =       `MON_vif.data_wdata_o;
                                `uvm_info(`gtn,$sformatf("MONITOR: DATA Collected :\n%s", seq_data.sprint()),UVM_LOW)
                                mem_req_fifo_lsu.write(seq_data); /// Write the Packets to TLM FIFO PORT
                                `uvm_info(`gtn,"DATA sent from MONITOR to SEQUENCER in Load Store unit",UVM_LOW)
                                @(negedge `MON_vif.data_gnt_i);
                        end
                end
        endtask : run_phase

endclass : ibex_monitor_load_store


