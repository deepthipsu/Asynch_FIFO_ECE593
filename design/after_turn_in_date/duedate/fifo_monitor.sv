/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class fifo_write_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_write_monitor)
  
  virtual uvm_interface vif;
  fifo_sequence_item item;
  
  uvm_analysis_port #(fifo_sequence_item) monitor_port;
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_write_monitor", uvm_component parent);
    super.new(name, parent);
    //`uvm_info("MONITOR_CLASS", "Inside Write Monitor Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("MONITOR_CLASS", "Build Phase Write Monitor !", UVM_HIGH)
    
    monitor_port = new("monitor_port", this);
    
    if(!(uvm_config_db #(virtual uvm_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   // `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    //`uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_HIGH)
    item = fifo_sequence_item::type_id::create("item");
    forever begin
      //item = fifo_sequence_item::type_id::create("item");
	//@(posedge vif.wclk) begin
      wait(vif.winc);
	//item.wdata = vif.wdata;
      item.winc = vif.winc;
      item.wptr2 = vif.wptr2;
      item.wrst_n = vif.wrst_n;
      item.wfull = vif.wfull;
  //`uvm_info("MONITOR", $sformatf("DATA =%d  TransactionID =%d", vif.wdata, burst_count), UVM_LOW)
@(posedge vif.wclk)
monitor_port.write(item);
//end

    end
        
  endtask: run_phase
  
endclass: fifo_write_monitor






class fifo_read_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_read_monitor)
  
  virtual uvm_interface vif;
  fifo_sequence_item item;
  
  uvm_analysis_port #(fifo_sequence_item) monitor_port;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_read_monitor", uvm_component parent);
    super.new(name, parent);
    //`uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new 
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    
    monitor_port = new("monitor_port", this);
    
    if(!(uvm_config_db #(virtual uvm_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end
    
  endfunction: build_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_HIGH)
    item = fifo_sequence_item::type_id::create("item");
    forever begin
      //item = fifo_sequence_item::type_id::create("item");
      @(posedge vif.rclk) begin
	//wait(vif.rinc);
      item.rdata = vif.rdata;
      item.rinc = vif.rinc;  
      item.rptr2 = vif.rptr2;
      item.wrst_n = vif.wrst_n;
      item.rempty = vif.rempty;    
 // `uvm_info("MONITOR", $sformatf("DATA =%d  TransactionID =%d", vif.wdata, burst_count), UVM_LOW)
      // send item to scoreboard
@(posedge vif.rclk) //begin
 monitor_port.write(item);
end
    end     
  endtask: run_phase
endclass: fifo_read_monitor
