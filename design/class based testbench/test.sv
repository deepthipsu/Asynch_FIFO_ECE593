//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Test for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////


import definitions::*;
`include "environment.sv"
program test(intf intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(intf);
    
    //setting the repeat count of generator as 10, means to generate 10 packets
    env.gen.repeat_count = 30;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram
