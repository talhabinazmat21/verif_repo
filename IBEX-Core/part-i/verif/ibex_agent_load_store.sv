class ibex_agent_load_store extends uvm_agent;


                `uvm_component_utils_begin(ibex_agent_load_store)
                        `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_DEFAULT)
                 `uvm_component_utils_end

        ibex_driver_load_store drv_lsu;
        ibex_monitor_load_store mon_lsu;
        ibex_sequencer_load_store seqr_lsu;

        function new(string name = "ibex_agent_load_store", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(is_active == UVM_ACTIVE) begin
                        seqr_lsu = ibex_sequencer_load_store::type_id::create("seqr_lsu", this);
                        drv_lsu = ibex_driver_load_store::type_id::create("drv_lsu",this);
                end
                mon_lsu = ibex_monitor_load_store::type_id::create("mon_lsu", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                if(is_active == UVM_ACTIVE) begin
                drv_lsu.seq_item_port.connect(seqr_lsu.seq_item_export);
        end
                mon_lsu.mem_req_fifo_lsu.connect(seqr_lsu.mem_request_fifo_lsu.analysis_export);
                $display("All connections done");
        endfunction : connect_phase

endclass : ibex_agent_load_store

