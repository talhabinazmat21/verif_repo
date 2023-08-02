class ibex_sequencer_instruction extends uvm_sequencer #(ibex_seq_item_instruction);

  uvm_tlm_analysis_fifo #(ibex_seq_item_instruction) mem_request_fifo_ins;

  `uvm_component_utils(ibex_sequencer_instruction)

  function new(string name = "ibex_sequencer_instruction", uvm_component parent = null);
    super.new(name, parent);
    mem_request_fifo_ins = new("mem_request_fifo_ins", this);
  endfunction : new

endclass : ibex_sequencer_instruction

