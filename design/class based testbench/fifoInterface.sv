//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: interface for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// interface help from: https://www.chipverify.com/systemverilog/systemverilog-interface
//////////////////////////////////////////////////////////
import definitions::*;

interface intf (input wclk, rclk);
  logic [DATASIZE-1:0] rdata;
  logic wfull;
  logic rempty;
  logic [DATASIZE-1:0] wdata;
  logic winc, wrst_n;
  logic rinc, rrst_n;

  //modport TB ( //modport from the testbench's perspective
    //input  wdata, winc, wclk, wrst_n, rinc, rclk, rrst_n,
    //output rdata, wfull,rempty);

  modport DUT ( // modport from the DUT's perspective
    output rdata, wfull, rempty,
    input  wdata, winc, wclk, wrst_n, rinc, rclk, rrst_n);

endinterface
