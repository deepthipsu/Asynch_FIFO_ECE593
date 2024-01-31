
/***********************************************************************
  $FILENAME    : async_fifo_bfm.svh

  $TITLE       : Bus Functional Model (BFM) interface definition

  $DATE        : 11 Nov 2017

  $VERSION     : 1.0.0

  $DESCRIPTION : 

Code is from: https://github.com/akzare/Async_FIFO_Verification
Verification test case for an asynchronous FIFO based on Systemverilog Object Oriented concepts and also UVM. The general architecture and implementation of the code has been taken from the UVM primer (Ray Salemi):

https://github.com/rdsalemi/uvmprimer

However the presented verification code in this test case is manipulated to be fitted for the special use case of an asynchronous FIFO.

The RTL source code for the asynchronous FIFO is taken from (Jason Yu):

http://www.verilogpro.com/asynchronous-fifo-design/

Which takes the Asynchronous FIFO design in SystemVerilog translated from Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

************************************************************************/


interface async_fifo_bfm;
  import async_fifo_pkg::*;

  //
  // DUT interface section
  //
  bit winc;
  bit wclk;
  bit wrst_n;
  bit rinc;
  bit rclk;
  bit rrst_n;
  logic [FIFO_DATA_WIDTH-1:0] wdata;

  wire [FIFO_DATA_WIDTH-1:0] rdata;
  wire wfull;
  wire rempty;



  //
  // Internal signals section
  //

  // Indicates the moment when all the push transactions are finished
  bit rdDone;
  // Indicates the moment when all the pop transactions are finished
  bit wrDone;

  // Number of write transactions to FIFO
  integer wr_cmds;
  // Number of read transactions from FIFO
  integer rd_cmds;




  //
  // Clock generator
  //
  initial begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #10ns wclk = ~wclk; // Fast clock zone
      forever #35ns rclk = ~rclk; // Slow clock zone
    join
  end


  //
  // Initialize internal signals
  //
  initial begin
    wr_cmds = 25;
    rd_cmds = 25;
    rdDone = 0;
    wrDone = 0;
  end


  //
  // Reset input/output interfaces of FIFO
  //
  task reset_rdwr();
  begin
    $write("%dns : bfm::Asserting reset on both read/write sides\n", $time);
    winc = 1'b0;
    wdata = '0;
    wrst_n = 1'b0;
    rinc = 1'b0;
    rrst_n = 1'b0;
    repeat(5) @(posedge wclk);
    wrst_n = 1'b1;
    repeat(1) @(posedge rclk);
    #2
    rrst_n = 1'b1;
    repeat(2) @(posedge rclk);
    $write("%dns : bfm::Done asserting reset on both read/write sides\n", $time);
  end
  endtask : reset_rdwr


  //
  // Pushing data into FIFO
  //
  task genPush();
  begin
    bit [FIFO_DATA_WIDTH-1:0] data;
    for (integer i  = 0; i < wr_cmds; i++)  begin
       data = $random();
       @ (negedge wclk);
       while (wfull == 1'b1) begin
        winc  = 1'b0;
        wdata = {(FIFO_DATA_WIDTH){1'b0}};
        @ (negedge wclk); 
       end
       winc  = 1'b1;
       wdata = data;
       $display("%dns : bfm::Pushing %h to FIFO", $time, wdata);
    end
    @ (negedge wclk);
    winc  = 1'b0;
    wdata= {(FIFO_DATA_WIDTH){1'b0}};

    repeat (10) @ (posedge wclk);
    wrDone = 1;
  end
  endtask : genPush


  //
  // Poping data from FIFO
  //
  task genPop();
  begin
    for (integer i = 0; i < rd_cmds; i++) begin
       @ (posedge rclk);
       while (rempty == 1'b1) begin
         rinc = 1'b0;
         @ (posedge rclk); 
       end
       rinc = 1'b1;
    end
    @ (posedge rclk);
    rinc = 1'b0;

    repeat (10) @ (posedge rclk);
    rdDone = 1;
  end
  endtask : genPop


  //
  // Waiting until the verification system finishes all the Push/Pop transactions
  //
  task wait_4_rdwr_done();
  begin
    while (!wrDone) begin
      @ (posedge wclk);
    end
    while (!rdDone) begin
      @ (posedge rclk);
    end
  end
  endtask : wait_4_rdwr_done

endinterface : async_fifo_bfm