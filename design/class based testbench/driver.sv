//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Driver class for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////


import definitions::*;

class driver;
int no_transactions;

logic [1:0] write_count = 0; // write idle cyle is 2
logic [1:0] read_count = 0; // read idle cycle is 1
logic [10:0] burst_count = 0; // 2^10 = 1024 

virtual intf vif;

mailbox gen2driv;
transaction trans;

function new(virtual intf vif, mailbox gen2driv);
this.vif = vif;
this.gen2driv = gen2driv;
endfunction
  
task reset;
  //wait(vif);
  $display("[ DRIVER ] ----- Reset Started -----");
  vif.wdata <= 0;
  vif.rdata <= 0;
  //vif.rempty <= 1;
  //vif.wfull <= 0;
  vif.winc <= 0;
  vif.rinc <= 0;
  vif.wrst_n <= 0;
  vif.rrst_n <= 0; 
  #10;
  vif.wrst_n <= 1;
  vif.rrst_n <= 1;
  vif.winc <= 1;   
  //vif.rinc <= 1;  
  //wait(!vif);
  $display("[ DRIVER ] ----- Reset Ended   -----");
endtask

  task main;
  $display("[ DRIVER ] ----- in main  -----");

    forever begin

//@( posedge vif.wclk or posedge vif.rclk) begin

    
    @( posedge vif.wclk) begin

//  $display("[ DRIVER ] ----- in wclk  -----");
   // if (vif.winc && !vif.wfull) begin
if (!vif.wfull) begin
    if (write_count == WRITE_PERIOD) begin

    gen2driv.get(trans);
    vif.wdata <= trans.wdata;

vif.winc <= 1;
    write_count <= 0;
    end
    else begin
    write_count <= write_count +1;
vif.winc <= 0;
    end
    end
//$display("write_count = %d, write_period = %d,", write_count, WRITE_PERIOD);

   // trans.display("[ Driver ]");
    no_transactions++;
//$display("---transactions = %0d", no_transactions);
 //$display("[ DRIVER ] ----- in wclk2  -----");
    if (vif.winc && !vif.wfull && write_count == WRITE_PERIOD) begin
    if (burst_count == BURST_LENGTH -1) begin
    burst_count <= 0;
    #1000;
    end
    else begin
    burst_count <= burst_count +1;
$display("---burst count = %0d", burst_count);
    end
    end
end    

//end
/*
    forever begin
@( posedge vif.rclk) begin

  $display("[ DRIVER ] ----- in rclk  -----");
    if (vif.rempty) begin
    read_count <= 0;
vif.rinc =1;
    end
    else if (read_count == READ_PERIOD) begin
    
    read_count <= 0;
    end
    else begin
    read_count <= read_count +1;
    //rinc =0;
    end
    end
*/

/*
   @(posedge vif.wclk) begin
 $display("[ DRIVER ] ----- in wclk2  -----");
    if (vif.winc && !vif.wfull && write_count == WRITE_PERIOD) begin
    if (burst_count == BURST_LENGTH -1) begin
    burst_count <= 0;
    #1000;
    end
    else begin
    burst_count <= burst_count +1;
$display("---burst count = %0d", burst_count);
    end
    end
   
end
@( posedge vif.wclk) begin
   // trans.display("[ Driver ]");
    no_transactions++;
$display("---transactions = %0d", no_transactions);
end*/



end
endtask

task main1;
  $display("[ DRIVER ] ----- in main1  -----");


    forever begin
@( posedge vif.rclk) begin

//  $display("[ DRIVER ] ----- in rclk  -----");
    if (vif.rempty) begin
    read_count <= 0;
vif.rinc =1;
    end
    else if (read_count == READ_PERIOD) begin
    vif.rinc =1;
    read_count <= 0;
    end
    else begin
    read_count <= read_count +1;
    vif.rinc =0;
    end
    end




end
endtask

endclass
