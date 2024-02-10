//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: generator class for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////


import definitions::*;

class generator;
rand transaction trans;

mailbox gen2driv;

event ended;

int repeat_count;

function new(mailbox gen2driv);
  this.gen2driv = gen2driv;
endfunction

task main();
$display("Generator started");
  repeat(repeat_count) begin
  trans= new();
  if(!trans.randomize()) $fatal("Gen:: trans randomization failed");
      trans.display("[ Generator ]");
      gen2driv.put(trans);
  end
  -> ended;
endtask
endclass
