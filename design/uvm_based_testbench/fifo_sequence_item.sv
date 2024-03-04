//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-22-24
// Description: UVM item_seq for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// UVM testbench architecture help from https://verificationguide.com/uvm/uvm-testbench-architecture/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



import definitions::*;
import uvm_pkg::*;

class fifo_sequence_item extends uvm_sequence_item;
  //Utility and Field macros
`include "uvm_macros.svh"

// data and control fields
  logic [DATASIZE-1:0] rdata;
  rand logic wfull;
  rand logic rempty;
  rand logic [DATASIZE-1:0] wdata;
  rand logic winc, wrst_n;
  rand logic rinc, rrst_n;
  logic [ADDRSIZE :0] rptr2, wptr2;

  `uvm_object_utils_begin(fifo_sequence_item)
    `uvm_field_int(rdata,UVM_ALL_ON)
    `uvm_field_int(wfull,UVM_ALL_ON)
    `uvm_field_int(rempty,UVM_ALL_ON)
    `uvm_field_int(winc,UVM_ALL_ON)
    `uvm_field_int(rinc,UVM_ALL_ON)
    `uvm_field_int(wrst_n,UVM_ALL_ON)
    `uvm_field_int(rrst_n,UVM_ALL_ON)
    `uvm_field_int(rptr2,UVM_ALL_ON)
    `uvm_field_int(wptr2,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_object_utils_end


  function new(string name = "fifo_sequence_item");
    super.new(name);
  endfunction

endclass: fifo_sequence_item


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class fifo_sequencer extends uvm_sequencer#(fifo_sequence_item);
`include "uvm_macros.svh"
 `uvm_component_utils(fifo_sequencer)
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_sequencer", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SEQR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQR_CLASS", "Build Phase!", UVM_HIGH)
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQR_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  
endclass: fifo_sequencer


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class fifo_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_sequence)
  
fifo_sequence_item req;

  //Constructor
  function new(string name = "fifo_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  virtual task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
    req = fifo_sequence_item::type_id::create("req");
	start_item(req);    
	  if(!req.randomize()) $fatal("randomization failed");
	finish_item(req);
  endtask: body
  
endclass: fifo_sequence



class fifo_write_sequence extends fifo_sequence;
  `uvm_object_utils(fifo_write_sequence)
  
parameter repeat_counts = 10;

  fifo_sequence_item item;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "fifo_write_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
repeat(repeat_counts) begin
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with {rinc == 1'b0;});
    finish_item(item);
        end
//#10;
  endtask: body
  
endclass: fifo_write_sequence


class fifo_read_sequence extends fifo_sequence;
  `uvm_object_utils(fifo_read_sequence)
  
  fifo_sequence_item item;
  parameter repeat_counts = 10;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "fifo_read_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
repeat(repeat_counts) begin
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with {winc == 1'b0;});
    finish_item(item);
        end
  endtask: body
  
endclass: fifo_read_sequence


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
    super.run_phase(phase);
    `uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_HIGH)
//item = fifo_sequence_item::type_id::create("item");  
 drive_reset(item);  
    forever begin
      item = fifo_sequence_item::type_id::create("item"); 
      seq_item_port.get_next_item(item);
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
        vif.wdata <= 0;
        vif.rdata <= 0;
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
                        //no_transactions++;
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
	//join
	end
endtask: drive_write

task drive_read(fifo_sequence_item item);
	if (vif.rrst_n == 1) begin
    @(posedge vif.rclk) begin
	if (read_count == READ_PERIOD ) begin
		vif.rinc = 1;
		read_count <= 0;
        end
        else begin
		vif.rinc <= 0;
		read_count <= read_count +1;
	end
        end
	end
  endtask: drive_read

endclass: fifo_driver


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
    `uvm_info("MONITOR_CLASS", "Inside Write Monitor Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase Write Monitor !", UVM_HIGH)
    
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
	//@(posedge vif.wclk) begin
      wait(vif.winc);
	//item.wdata = vif.wdata;
      item.winc = vif.winc;
      item.wptr2 = vif.wptr2;
      item.wrst_n = vif.wrst_n;
      item.wfull = vif.wfull;
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
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    
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
      // send item to scoreboard
@(posedge vif.rclk) //begin
 monitor_port.write(item);
end
    end
        
  endtask: run_phase
  
endclass: fifo_read_monitor



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
    `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)
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
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)
    
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
    `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)
    
    rdrv = fifo_driver::type_id::create("rdrv", this);
    rmon = fifo_read_monitor::type_id::create("rmon", this);
    rseqr = fifo_sequencer::type_id::create("rseqr", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)
    
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class fifo_scoreboard extends uvm_test;
  `uvm_component_utils(fifo_scoreboard)
  
  uvm_analysis_imp #(fifo_sequence_item, fifo_scoreboard) scoreboard_port;
  
  fifo_sequence_item transactions[$];
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)
    
   
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write(fifo_sequence_item item);
    transactions.push_back(item);
  endfunction: write 
  
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_HIGH)
   
    forever begin
      /*
      // get the packet
      // generate expected value
      // compare it with actual value
      // score the transactions accordingly
      */

      fifo_sequence_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);

    end
    
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //Compare : Generate Expected Result and Compare with Actual
  //--------------------------------------------------------
  task compare(fifo_sequence_item curr_trans);
    logic [8:0] expected;
    logic [8:0] actual;
actual = curr_trans.rdata;
expected = mem[curr_trans.rptr2];   

if( curr_trans.rinc) begin
	//if(mem[curr_trans.rptr2] != curr_trans.rdata)    
	if(actual != expected) begin
      `uvm_error("COMPARE", $sformatf("Transaction failed! ACT=%d, EXP=%d", actual, expected))
    end
    else begin
      // Note: Can display the input and op_code as well if you want to see what's happening
      `uvm_info("COMPARE", $sformatf("Transaction Passed! ACT=%d, EXP=%d", actual, expected), UVM_LOW)
    end
    end
//end
  endtask: compare
  
endclass: fifo_scoreboard



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




class fifo_environment extends uvm_env;
  `uvm_component_utils(fifo_environment)
  
  fifo_write_agent wagnt;
  fifo_read_agent ragnt;
  fifo_scoreboard scb;
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_environment", uvm_component parent);
    super.new(name, parent);
    `uvm_info("ENV_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV_CLASS", "Build Phase!", UVM_HIGH)
    
    wagnt = fifo_write_agent::type_id::create("wagnt", this);
    ragnt = fifo_read_agent::type_id::create("ragnt", this);
    scb = fifo_scoreboard::type_id::create("scb", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase!", UVM_HIGH)
    
    wagnt.wmon.monitor_port.connect(scb.scoreboard_port);
    ragnt.rmon.monitor_port.connect(scb.scoreboard_port);   
  endfunction: connect_phase
  
endclass: fifo_environment


//////////////////////////////////////////////////////////////////////////////////////////////

class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_environment env;
  fifo_sequence reset_seq;
  fifo_write_sequence wtest_seq;
  fifo_read_sequence rtest_seq;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

    env = fifo_environment::type_id::create("env", this);
     wtest_seq = fifo_write_sequence::type_id::create("wtest_seq");
	rtest_seq = fifo_read_sequence::type_id::create("rtest_seq");
  endfunction: build_phase

  //--------------------------------------------------------
  //End of Elaboration Phase
  //--------------------------------------------------------
virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  //Report Phase
  //--------------------------------------------------------
virtual function void report_phase(uvm_phase phase);
	uvm_report_server svr;
	super.report_phase(phase);
	svr = uvm_report_server::get_server();
	if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
		`uvm_info(get_type_name(),"===============ECE593 TEST FAILED================",UVM_NONE)
	end
	else begin
		`uvm_info(get_type_name(),"===============ECE593 TEST PASSED================",UVM_NONE)
	end
endfunction: report_phase
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)

    phase.raise_objection(this);

    //reset_seq
    //reset_seq = fifo_sequence::type_id::create("reset_seq");
    //reset_seq.start(env.wagnt.wseqr);
    //reset_seq.start(env.ragnt.rseqr);
    //#10;
//phase.raise_objection(this);

    repeat(10) begin
      //test_seq
	fork
      wtest_seq.start(env.wagnt.wseqr);
	rtest_seq.start(env.ragnt.rseqr);
join_any
    end
    
    phase.drop_objection(this);

  endtask: run_phase


endclass: fifo_test
