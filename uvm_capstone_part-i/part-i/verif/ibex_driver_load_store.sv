`include "dv_macros.svh"
`define DRV_vif data_mem_if.lsu_driver_ports.lsu_driver_clocking_block
`define drv_vif data_mem_if.async_ports

class ibex_driver_load_store extends uvm_driver #(ibex_seq_item_load_store);

        `uvm_component_utils(ibex_driver_load_store)

        virtual interface ibex_data_mem_if data_mem_if;
        ibex_seq_item_load_store seq_data;

        function new(string name = "ibex_driver_load_store", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

         function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                seq_data = ibex_seq_item_load_store::type_id::create("seq_data",this);

                    if (!uvm_config_db#(virtual ibex_data_mem_if)::get(this,"","data_mem_if", data_mem_if)) begin
                        `uvm_error("NO-VIF","uvm_config_db::get failed")
                end
                else begin
                  `uvm_info(`gtn,"VIF set in Load Store Unit DRIVER successfully!",UVM_LOW)
                end

        endfunction : build_phase


        task run_phase(uvm_phase phase);
                super.run_phase(phase);

        data_mem_if.reset();

                forever begin
                        seq_data = ibex_seq_item_load_store::type_id::create("seq_data",this);
                        seq_item_port.get_next_item(seq_data);
                        `uvm_info(`gtn, "DATA received from SEQUENCER in run_phase of DRIVER",UVM_HIGH)
                        `drv_vif.data_gnt_i             =       seq_data.data_gnt_i;
                        `DRV_vif.data_err_i             <=      seq_data.data_err_i;
                        @(posedge data_mem_if.clk);
                        `DRV_vif.data_gnt_i     <=      1'b0;
                        `DRV_vif.data_rdata_i   <=      seq_data.data_rdata_i;
                        `DRV_vif.data_rvalid_i  <=      seq_data.data_rvalid_i;
                        @(posedge data_mem_if.clk);
                        `DRV_vif.data_rvalid_i   <=     1'b0;
                        seq_item_port.item_done();
                        `uvm_info(`gtn, "DATA sent from DRIVER to DUT ",UVM_HIGH)
                end
        endtask : run_phase

endclass : ibex_driver_load_store


