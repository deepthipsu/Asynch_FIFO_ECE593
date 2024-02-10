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

function new(virtual intf vif, mailbox gen2driv);
this.vif = vif;
this.gen2driv = gen2driv;
endfunction
  
task reset;
  //wait(vif);
  $display("[ DRIVER ] ----- Reset Started -----");
  vif.wdata <= 0;
  vif.rdata <= 0;
  vif.rempty <= 1;
  vif.wfull <= 0;
  vif.winc <= 0;
  vif.rinc <= 0;
  vif.wrst_n <= 0;
  vif.rrst_n <= 0; 
  #10;
  vif.wrst_n <= 1;
  vif.rrst_n <= 1;
  vif.winc <= 1;   
  //wait(!vif);
  $display("[ DRIVER ] ----- Reset Ended   -----");
endtask

  task main;
    forever begin
    transaction trans;
    gen2driv.get(trans);
    @(posedge vif.wclk);
    if (vif.winc && !vif.wfull) begin
    if (write_count == WRITE_PERIOD) begin
    vif.wdata <= $random;
    write_count <= 0;
    end
    else begin
    write_count <= write_count +1;
    end
    end
    

    @ (posedge vif.rclk);
    if (vif.rempty) begin
    read_count <= 0;
    end
    else if (read_count == READ_PERIOD) begin
    vif.rinc =1;
    read_count <= 0;
    end
    else begin
    read_count <= read_count +1;
    //rinc =0;
    end
    


    @ (posedge vif.wclk)
    if (vif.winc && !vif.wfull && write_count == WRITE_PERIOD) begin
    if (burst_count == BURST_LENGTH -1) begin
    burst_count <= 0;
    #1000;
    end
    else begin
    burst_count <= burst_count +1;
    end
    end
   
    @(posedge vif);
    trans.display("[ Driver ]");
    no_transactions++;
end
endtask

endclass
