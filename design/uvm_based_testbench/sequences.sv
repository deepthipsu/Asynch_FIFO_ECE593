//////////////////////////////////////////////////////////
// Author: Sai Sukitha Puli (puli2@pdx.edu)
// Date: 02-29-24
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
  
parameter repeat_counts = 15;

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
  parameter repeat_counts = 15;
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

// Sequences for each test scenario
// write only sequence
class write_random_data_sequence extends fifo_write_sequence;
  task body();
    `uvm_info("SEQ", "Starting Write Sequence with Random Data", UVM_HIGH)
    repeat(repeat_counts) begin
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { rinc == 1'b0; });
      finish_item(item);
    end
  endtask
endclass: write_random_data_sequence


//read only
class read_empty_sequence extends fifo_read_sequence;
  task body();
    `uvm_info("SEQ", "Starting Read Sequence with Empty FIFO Handling", UVM_HIGH)
    repeat(repeat_counts) begin
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { winc == 1'b0; });
      finish_item(item);
    end
  endtask
endclass: read_empty_sequence



//sequential write and read 
class sequential_write_read_sequence extends fifo_sequence;
  task body();
    `uvm_info("SEQ", "Starting Sequential Write and Read Sequence", UVM_HIGH)
    repeat(repeat_counts) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { rinc == 1'b0; });
      finish_item(req);
      // Delay before reading
      #10;
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { winc == 1'b0; });
      finish_item(req);
    end
  endtask
endclass: sequential_write_read_sequence

//simultaneous write and read Sequenceclass simultaneous_write_read_sequence extends fifo_sequence;
  task body();
    `uvm_info("SEQ", "Starting Simultaneous Write and Read Sequence", UVM_HIGH)
    repeat(repeat_counts) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { rinc == 1'b0; winc == 1'b0; });
      finish_item(req);
    end
  endtask
endclass: simultaneous_write_read_sequence

//write full Sequenceclass write_full_sequence extends fifo_write_sequence;
  task body();
    `uvm_info("SEQ", "Starting Write-Full Sequence", UVM_HIGH)
    // Fill the FIFO to capacity
    repeat(FIFO_CAPACITY) begin
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { rinc == 1'b0; });
      finish_item(item);
    end
    // Attempt to write to a full FIFO
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with { rinc == 1'b0; });
    finish_item(item);
  endtask
endclass: write_full_sequence


//read empty Sequence
class read_empty_sequence extends fifo_read_sequence;
  task body();
    `uvm_info("SEQ", "Starting Read-Empty Sequence", UVM_HIGH)
    // Attempt to read from an empty FIFO
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with { winc == 1'b0; });
    finish_item(item);
  endtask
endclass: read_empty_sequence

//reset condition
class reset_behavior_sequence extends fifo_sequence;
  task body();
    `uvm_info("SEQ", "Starting Reset Behavior Sequence", UVM_HIGH)
    // Assert reset signal
    assert(env.wagnt.wdrv.drive_reset(req) && env.ragnt.rdrv.drive_reset(req));
    // Delay to allow reset to take effect
    #10;
  endtask
endclass: reset_behavior_sequence
