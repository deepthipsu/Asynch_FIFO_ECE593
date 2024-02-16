//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Testbench for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////
`timescale 1ns/100ps

import definitions::*;
module tb_fifo;

     logic wclk = 0;
     logic rclk = 0;

    always #1.00 wclk = ~wclk;
    always #2.22 rclk = ~rclk;
  
 intf fifoTBintf(wclk, rclk); // create interface object


  //Testcase instance, interface handle is passed to test as an argument
  test t1(fifoTBintf);

  // Instantiate the FIFO Memory module
 // fifo1 FIFO_inst (.*);
  fifo FIFO_inst (fifoTBintf.DUT); //instantiate the DUT, pass the TB modport to it

  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule