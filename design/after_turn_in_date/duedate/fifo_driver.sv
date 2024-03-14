/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class fifo_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(fifo_driver)
  
  virtual uvm_interface vif;
  fifo_sequence_item item;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
    //`uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)
    
    if(!(uvm_config_db #(virtual uvm_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end
  endfunction: build_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //`uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    //`uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_HIGH)
//item = fifo_sequence_item::type_id::create("item");  
 drive_reset(item);  
    while (burst_read != BURST_LENGTH) begin
      item = fifo_sequence_item::type_id::create("item"); 
      seq_item_port.get_next_item(item);
/*if (burst_read == 322) begin
 drive_reset1(item);
end  */
fork
      drive_write(item);
	drive_read(item);
join_any 
  seq_item_port.item_done();
    end
 
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //[Method] Drive
  //--------------------------------------------------------
  virtual task drive_reset(fifo_sequence_item item);
        //#10;
	vif.wdata <= 1'bx;
        //vif.rdata <= 0;
        vif.winc <= 0;
        vif.rinc <= 0;
        vif.wrst_n <= 0;
        vif.rrst_n <= 0; 
        #10;
        vif.wrst_n <= 1;
        vif.rrst_n <= 1;
        vif.winc <= 1;   
        vif.rinc <= 1;  
  endtask: drive_reset
  
  task drive_write(fifo_sequence_item item);
	if (vif.wrst_n == 1) begin
	//fork
    @(posedge vif.wclk) begin
	if (!vif.wfull) begin
		if (write_count == WRITE_PERIOD) begin
    			vif.wdata <= item.wdata;
    			vif.winc <= 1;
                        write_count <= 0;
                        burst_count <= burst_count +1;
			//count <= count +1;
 // `uvm_info("DRIVER", $sformatf("DATA =%d  TransactionID =%d", item.wdata, burst_count), UVM_LOW)
                            if (burst_count == BURST_LENGTH -1) begin
                                burst_count <= 0;
				vif.wrst_n <= 0;
				vif.wdata <= 'x;
				vif.winc <=0;
                            end 
                    end
                    else begin
                        write_count <= write_count +1;
                        vif.winc <= 0;
                    end
                end
                end
	//join
	end
	else 
@(posedge vif.wclk); 
endtask: drive_write

task drive_read(fifo_sequence_item item);
	if (vif.rrst_n == 1) begin
    @(posedge vif.rclk) begin
	if (read_count == READ_PERIOD ) begin
		vif.rinc = 1;
		read_count <= 0;
		burst_read <=  burst_read+1;
                            if (burst_read == BURST_LENGTH-1) begin
                                burst_read <= 0;
				vif.rrst_n <= 0;
				vif.rinc <=1;
                            end 
        end
        else begin
		vif.rinc <= 0;
		read_count <= read_count +1;
	end
        end
	end
@(posedge vif.rclk);
  endtask: drive_read

  virtual task drive_reset1(fifo_sequence_item item);
        #20;
	vif.wdata <= 1'bx;
        //vif.rdata <= 0;
        vif.winc <= 0;
        vif.rinc <= 0;
        vif.wrst_n <= 0;
        vif.rrst_n <= 0; 
        #20;

  endtask: drive_reset1

endclass: fifo_driver