/***********************************************************************
  $FILENAME    : top.svh

  $TITLE       : Top hierarchy module

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


module top;
  import   async_fifo_pkg::*;


  //
  // Instantiate FIFO (DUT)
  //
  async_fifo #(FIFO_DATA_WIDTH, FIFO_MEM_ADDR_WIDTH) DUT
                 (.winc(bfm.winc),
                  .wclk(bfm.wclk),
                  .wrst_n(bfm.wrst_n),
                  .rinc(bfm.rinc),
                  .rclk(bfm.rclk),
                  .rrst_n(bfm.rrst_n),
                  .wdata(bfm.wdata),
                  .rdata(bfm.rdata),
                  .wfull(bfm.wfull),
                  .rempty(bfm.rempty));


  //
  // Instantiate Bus Functional Model (BFM) interface
  //
  async_fifo_bfm bfm();


  //
  // Instantiate testbench
  //
  tb testbench_h;


  initial begin
    testbench_h = new(bfm);
    testbench_h.execute();
  end


  //
  // Dump the changes in the values of nets and registers in async_fifo.vcd
  //
  initial begin
    $dumpfile("async_fifo.vcd");
    $dumpvars();
  end

endmodule : top
