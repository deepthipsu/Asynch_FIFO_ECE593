import uvm_pkg::*;
import questa_uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(fifo_driver)
  
  virtual fifo_interface vif;
  fifo_sequence_item item;
      logic [1:0] write_count = 0; // write idle cyle is 2
    logic [1:0] read_count = 0; // read idle cycle is 1
    logic [10:0] burst_count = 0; // 2^10 = 1024 
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)
    
    if(!(uvm_config_db #(virtual fifo_interface)::get(this, "*", "vif", vif))) begin
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
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_HIGH)
    
    forever begin
      item = fifo_sequence_item::type_id::create("item"); 
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
    
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //[Method] Drive
  //--------------------------------------------------------
  task drive_reset(fifo_sequence_item item);
        vif.wdata <= 0;
        vif.rdata <= 0;
        vif.winc <= 0;
        vif.rinc <= 0;
        vif.wrst_n <= 0;
        vif.rrst_n <= 0; 
        #100;
        vif.wrst_n <= 1;
        vif.rrst_n <= 1;
        vif.winc <= 1;   
        vif.rinc <= 1;  
  endtask: drive_reset
  
  task drive_write(fifo_sequence_item item);
    forever begin
    @(posedge vif.wclk) begin
	if (!vif.wfull) begin
		if (write_count == WRITE_PERIOD) begin
    			vif.wdata <= item.wdata;
    			vif.winc <= 1;
                        write_count <= 0;
                        no_transactions++;
                        burst_count <= burst_count +1;
                            if (burst_count == BURST_LENGTH -1) begin
                                burst_count <= 0;
                            end 
                    end
                    else begin
                        write_count <= write_count +1;
                        vif.winc <= 0;
                    end
                end
                end
	end
  endtask: drive_write

  task drive_read(fifo_sequence_item item);
    forever begin
    @(posedge vif.rclk) begin
	if (vif.rempty) begin
		read_count <= 0;
		vif.rinc = 1;
	end
	else if (read_count == READ_PERIOD ) begin
		vif.rinc = 1;
		read_count <= 0;
        end
        else begin
		read_count <= read_count +1;
		vif.rinc <= 0;
	end
        end
	end
  endtask: drive_read

endclass: fifo_driver