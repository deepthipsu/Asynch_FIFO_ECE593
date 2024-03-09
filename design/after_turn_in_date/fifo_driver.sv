/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class fifo_write_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(fifo_write_driver)
  
  typedef fifo_sequence_item fifo_item_t;
  virtual uvm_interface vif;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_write_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)
    
    if(!(uvm_config_db #(virtual uvm_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end
  endfunction: build_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  virtual task run_phase (uvm_phase phase);
    //super.run_phase(phase);
    //`uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_HIGH)
    fifo_item_t item;
    forever begin
      seq_item_port.get_next_item(item);
      drive_write(item);
      seq_item_port.item_done();
    end
    
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //[Method] Drive
  //-------------------------------------------------------- 
 
  task drive_write(fifo_item_t item);
    do begin
    	vif.wdata <= item.wdata;
    	vif.winc <= item.winc;
      vif.wrst_n <= item.wrst_n;
      @(posedge vif.wclk);
    end
    while(vif.wfull);
endtask: drive_write 
endclass: fifo_write_driver





class fifo_read_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(fifo_read_driver)
  
  typedef fifo_sequence_item fifo_item_t;
  virtual uvm_interface vif;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_read_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)
    
    if(!(uvm_config_db #(virtual uvm_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end
  endfunction: build_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  virtual task run_phase (uvm_phase phase);
   // super.run_phase(phase);
   // `uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_HIGH)
    fifo_item_t item;
    forever begin
      seq_item_port.get_next_item(item);
      drive_read(item);
      seq_item_port.item_done();
    end
    
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //[Method] Drive
  //-------------------------------------------------------- 
 
  task drive_read(fifo_item_t item);
    	vif.rinc <= item.rinc;
      vif.rrst_n <= item.rrst_n;
      @(posedge vif.rclk);
endtask: drive_read 
endclass: fifo_read_driver