
//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Testbench for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////
`timescale 1ns/100ps

import uvm_pkg::*;
`include "uvm_macros.svh"

//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "interface_uvm.sv"
`include "fifo_sequence_item.sv"


module tb_fifo_uvm;

     logic wclk = 0;
     logic rclk = 0;

initial begin
    wclk = 0;
    forever begin
      wclk = ~wclk;
      #1;
    end
  end

 initial begin
    rclk = 0;
    forever begin
      rclk = ~rclk;
      #2.22;
    end
  end

//always #1.00 wclk = ~wclk;
//always #2.22 rclk = ~rclk;
  
 uvm_interface fifoTBintf(wclk, rclk); // create interface object

  // Instantiate the FIFO Memory module
 // fifo1 FIFO_inst (.*);
  fifo FIFO_inst (fifoTBintf.DUT); //instantiate the DUT, pass the TB modport to it

  //--------------------------------------------------------
  //Interface Setting
  //--------------------------------------------------------
  initial begin
    uvm_config_db #(virtual uvm_interface)::set(null, "*", "vif", fifoTBintf );
    //-- Refer: https://www.synopsys.com/content/dam/synopsys/services/whitepapers/hierarchical-testbench-configuration-using-uvm.pdf
  end
  



  initial begin 
    run_test("fifo_test");
  end

  initial begin
    #50000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end
  

  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule