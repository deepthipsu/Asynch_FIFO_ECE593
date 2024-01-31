/***********************************************************************
  $FILENAME    : tb.svh

  $TITLE       : Testbench module

  $DATE        : 11 Nov 2017

  $VERSION     : 1.0.0

  $DESCRIPTION : 

Code is from: https://github.com/akzare/Async_FIFO_Verification
Verification test case for an asynchronous FIFO based on Systemverilog Object Oriented concepts and also UVM. The general architecture and implementation of the code has been taken from the UVM primer (Ray Salemi):

https://github.com/rdsalemi/uvmprimer

However the presented verification code in this test case is manipulated to be fitted for the special use case of an asynchronous FIFO.

The RTL source code for the asynchronous FIFO is taken from (Jason Yu):

http://www.verilogpro.com/asynchronous-fifo-design/

Which takes the Asynchronous FIFO design in SystemVerilog translated from Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

************************************************************************/

import async_fifo_pkg::*;

class tb;

  // Bus Functional Model interface
  virtual async_fifo_bfm bfm;

  tester     tester_h;
  coverage   coverage_h;
  scoreboard scoreboard_h;
   

  //
  // Class constructor method
  //
  function new (virtual async_fifo_bfm b);
    bfm = b;
  endfunction : new


  //
  // This method launches all the subcomponents of the testbench concurrently
  //
  task execute();
    tester_h     = new(bfm);
    coverage_h   = new(bfm);
    scoreboard_h = new(bfm);

    fork
      coverage_h.execute();
      scoreboard_h.execute();
      tester_h.execute();
      join_none
  endtask : execute

endclass : tb
