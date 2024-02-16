//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Transaction class for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////


import definitions::*;

class transaction;

randc  logic [DATASIZE-1:0] wdata;
 logic [DATASIZE-1:0] rdata;
  logic [ADDRSIZE:0] wptr2;
  logic [ADDRSIZE:0] rptr2;
    logic wfull;
  logic rempty;
    rand logic winc;
  rand logic rinc;

  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- wdata = %0d rdata = %0d",wdata, rdata);
    $display("-------------------------");
endfunction

endclass
