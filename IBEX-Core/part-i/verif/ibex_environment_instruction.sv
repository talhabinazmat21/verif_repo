class ibex_environment_instruction extends uvm_env;

        `uvm_component_utils(ibex_environment_instruction)

        ibex_agent_instruction agt_ins;
        ibex_agent_load_store agt_data;

        function new(string name = "ibex_environment_instruction", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                agt_ins = ibex_agent_instruction::type_id::create("agt_ins",this);
                agt_data = ibex_agent_load_store::type_id::create("agt_data",this);
                //uvm_config_db #(uvm_active_passive_enum)::set(this,"*","is_active",UVM_DEFAULT);
        endfunction : build_phase

endclass:ibex_environment_instruction

