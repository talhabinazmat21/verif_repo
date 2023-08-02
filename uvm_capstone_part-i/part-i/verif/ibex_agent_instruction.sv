class ibex_agent_instruction extends uvm_agent;

        `uvm_component_utils_begin(ibex_agent_instruction)
                `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_DEFAULT)
    `uvm_component_utils_end

        ibex_sequencer_instruction ins_seqr;
        ibex_driver_instruction ins_drv;
        ibex_monitor_instruction ins_mon;

        function new(string name="ibex_agent_instruction", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(is_active == UVM_ACTIVE) begin
                        ins_seqr = ibex_sequencer_instruction::type_id::create("ins_seqr", this);
                        ins_drv = ibex_driver_instruction::type_id::create("ins_drv",this);
                end
                        ins_mon = ibex_monitor_instruction::type_id::create("ins_mon", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                if(is_active == UVM_ACTIVEUntitled Document 1) begin
                ins_drv.seq_item_port.connect(ins_seqr.seq_item_export);
        end
                ins_mon.mem_req_fifo_ins.connect(ins_seqr.mem_request_fifo_ins.analysis_export);
        endfunction : connect_phase


endclass:ibex_agent_instruction

