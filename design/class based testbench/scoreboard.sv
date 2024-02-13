//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-13-24
// Description: Scoreboard class for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-with-scb///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


import definitions::*;

class scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;

  //used to count the number of transactions
  int no_transactions;
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Compares the Actual result with the expected result
  task main;
  transaction trans;
    forever begin
      mon2scb.get(trans);
        if((trans.wdata) == trans.rdata)
          $display("Result is as Expected");
        else
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(trans.wdata),trans.rdata);
        no_transactions++;
      trans.display("[ Scoreboard ]");
    end
  endtask
  
endclass
