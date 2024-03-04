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
int repeat_count;

mailbox gen2driv;

event ended;


function new(mailbox gen2driv);
  this.gen2driv = gen2driv;
endfunction

task main();
$display("Generator started");
  for(int i = 1; i<=repeat_count; i++) begin 
  trans= new();
if (i <= repeat_count) assert(trans.randomize() with {trans.transactionID == i;}) 
	else $fatal("Gen:: trans randomization failed");
      trans.display("[ Generator ]");
      gen2driv.put(trans);
  end
  -> ended;
endtask
endclass
