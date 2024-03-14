
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class fifo_write_agent extends uvm_agent;
  `uvm_component_utils(fifo_write_agent)
  
  fifo_driver wdrv;
  fifo_write_monitor wmon;
  fifo_sequencer wseqr;
  //uvm_analysis_port #(fifo_sequence_item) wexport;
  virtual uvm_interface vif;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_write_agent", uvm_component parent);
    super.new(name, parent);
   // `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)
    //wexport = new("wexport", this);
    wdrv = fifo_driver::type_id::create("wdrv", this);
    wdrv.vif = vif;
    wmon = fifo_write_monitor::type_id::create("wmon", this);
    wmon.vif = vif;
    wseqr = fifo_sequencer::type_id::create("wseqr", this); 
  endfunction: build_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //`uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)
    
    wdrv.seq_item_port.connect(wseqr.seq_item_export);
    //wmon.wexport.connect(this.wexport);
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
endclass: fifo_write_agent


class fifo_read_agent extends uvm_agent;
  `uvm_component_utils(fifo_read_agent)
  
  fifo_driver rdrv;
  fifo_read_monitor rmon;
  fifo_sequencer rseqr;
  virtual uvm_interface vif;
  uvm_analysis_port#(fifo_sequence_item) rexport;
    
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_read_agent", uvm_component parent);
    super.new(name, parent);
    //`uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)
    
    rdrv = fifo_driver::type_id::create("rdrv", this);
    rmon = fifo_read_monitor::type_id::create("rmon", this);
    rseqr = fifo_sequencer::type_id::create("rseqr", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //`uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)
    
    rdrv.seq_item_port.connect(rseqr.seq_item_export);
    //rmon.monitor_port.connect(this.rexport); 
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
  endtask: run_phase
endclass: fifo_read_agent
