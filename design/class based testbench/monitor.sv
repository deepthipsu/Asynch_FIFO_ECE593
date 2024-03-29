//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Monitor for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-with-scb/
//////////////////////////////////////////////////////////

import definitions::*;

class monitor;
  //creating virtual interface handle
  virtual intf vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual intf vif,mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vif.wclk) begin
      wait(vif.winc);
      trans.wdata   = vif.wdata;
      trans.winc   = vif.winc; 
      trans.wptr2   = vif.wptr2;
      
      //mon2scb.put(trans);
      //trans.display("[ Monitor1 ]");
	end
      @(posedge vif.rclk) begin
      wait(vif.rinc);
      trans.rdata   = vif.rdata;  
      trans.rinc   = vif.rinc;
	  trans.rptr2   = vif.rptr2;
      trans.wfull   = vif.wfull;
      trans.rempty  = vif.rempty;     
      mon2scb.put(trans);
      //trans.display("[ Monitor2 ]");
	end
    end
  endtask

endclass