/***********************************************************************
  $FILENAME    : coverage.svh

  $TITLE       : Coverage class implementation

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

class coverage;

  // Bus Functional Model interface
  virtual async_fifo_bfm bfm;

  logic [FIFO_DATA_WIDTH-1:0] wdata;

  //
  // Coverage group definition
  //
  covergroup wdata_cov;

    write_data: coverpoint wdata {
      bins zeros = {'h00};
      bins others= {['h01:'hFE]};
      bins ones  = {'hFF};
    }

  endgroup


  //
  // Class constructor method
  //
  function new (virtual async_fifo_bfm b);
    wdata_cov = new();
    bfm = b;
  endfunction : new


  //
  // Execute method
  //
  task execute();
    forever begin : sampling_block
      @(posedge bfm.winc);
      wdata = bfm.wdata;
      wdata_cov.sample();
    end : sampling_block
  endtask : execute


endclass : coverage
