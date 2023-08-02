class ibex_sequencer_load_store extends uvm_sequencer #(ibex_seq_item_load_store);

  uvm_tlm_analysis_fifo #(ibex_seq_item_load_store) mem_request_fifo_lsu;

  `uvm_component_utils(ibex_sequencer_load_store)

  function new(string name = "ibex_sequencer_load_store", uvm_component parent = null);
    super.new(name, parent);
    mem_request_fifo_lsu = new("mem_request_fifo_lsu", this);
  endfunction : new

endclass : ibex_sequencer_load_store

