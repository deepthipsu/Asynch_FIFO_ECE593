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

covergroup zeros_or_ones_on_ops;

      a_leg: coverpoint fifoTBintf.wdata {
         bins zeros = {'h00};
         bins others= {['h01:'hFE]};
         bins ones  = {'hFF};
	 bins allBitsIn[] = {[8'b00000000:8'b11111111]};
      }

      b_leg: coverpoint fifoTBintf.rdata {
         bins zeros = {'h00};
         bins others= {['h01:'hFE]};
         bins ones  = {'hFF};
	 bins allBitsOut[] = {[8'b00000000:8'b11111111]};
      }
endgroup

covergroup fifoInterfaceSignalsCG;

      a_leg: coverpoint fifoTBintf.wrst_n {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }

      b_leg: coverpoint fifoTBintf.rrst_n {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }
      c_leg: coverpoint fifoTBintf.winc {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }

      d_leg: coverpoint fifoTBintf.rinc {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }
      e_leg: coverpoint fifoTBintf.wfull {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }

      f_leg: coverpoint fifoTBintf.rempty {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }
endgroup

zeros_or_ones_on_ops dataWrite;
zeros_or_ones_on_ops dataRead;
fifoInterfaceSignalsCG fifoInterfaceSignals;

initial begin : coverage
	dataWrite = new();
	dataRead = new();
	fifoInterfaceSignals = new();
	fork
	forever begin
		@(negedge wclk);
			dataWrite.sample();
			fifoInterfaceSignals.sample();
	end
	forever begin
		@(negedge rclk);
			dataRead.sample();
	end
	join_none
end: coverage	

  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
