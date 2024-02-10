//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Testbench for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////

import definitions::*;
module tb_fifo;
  
intf fifoTBintf(); // create interface object


  // Instantiate the FIFO Memory module
 // fifo1 FIFO_inst (.*);
  fifo FIFO_inst (fifoTBintf.DUT); //instantiate the DUT, pass the TB modport to it

  // Clock Generation
  initial begin
    fifoTBintf.wclk = 0;
    fifoTBintf.rclk = 0;

    // Toggle clocks every wclk=2 and rclk=4.4 time units respectively
fork
    forever #1 fifoTBintf.wclk = ~fifoTBintf.wclk;
    forever #2.22 fifoTBintf.rclk = ~fifoTBintf.rclk;
join
  end
  
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(fifoTBintf);
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
