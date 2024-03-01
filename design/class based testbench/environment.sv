//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Environment class for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "fifoInterface.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  
  //generator and driver instance
  generator gen;
  driver    driv;
  monitor   mon;
  scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //virtual interface
  virtual intf vif;
  
  //constructor
  function new(virtual intf vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb = new();
    
    //creating generator and driver
    gen  = new(gen2driv);
    driv = new(vif,gen2driv);
    mon  = new(vif,mon2scb);
    scb = new(mon2scb);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
  //$display("[ ENVIRONMENT -------- Task Test before gen.main call -----");
    gen.main();
  //$display("[ ENVIRONMENT -------- Task Test before driv.main call -----");
    driv.main();
    driv.main1();
    mon.main();
    scb.main();
    join_any
  endtask
  
  task test_reset();
    fork 
  //$display("[ ENVIRONMENT -------- Task Test before gen.main call -----");
    gen.main();
  //$display("[ ENVIRONMENT -------- Task Test before driv.main call -----");
    driv.main();
    //driv.main1();
	// driv.reset();
    mon.main();
    scb.main();
    join_any
  endtask

  task post_test();
    wait(gen.ended.triggered);
    //wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
//#3000;
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    //test_reset();
    post_test();
    $finish;
  endtask
  
endclass
