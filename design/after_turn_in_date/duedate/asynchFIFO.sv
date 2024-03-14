/////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 01-25-24
// Description: Asynchronous FIFO design in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
//////////////////////////////////////////////////////////

import definition::*;
`include "interface_uvm.sv"
// FIFO top-level module
module fifo (uvm_interface.DUT fifoIntf);

  logic [ADDRSIZE-1:0] waddr, raddr;
  logic [ADDRSIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  fifomem fifomem (
    .rdata(fifoIntf.rdata),
    .wdata(fifoIntf.wdata),
    .waddr(waddr),
    .raddr(raddr),
    .winc(fifoIntf.winc),
    .wfull(fifoIntf.wfull),
    .wclk(fifoIntf.wclk)
  );  
  
  sync_r2w sync_r2w (
    .wq2_rptr(wq2_rptr),
    .rptr(rptr),
    .wclk(fifoIntf.wclk),
    .wrst_n(fifoIntf.wrst_n)
  ); 

  sync_w2r sync_w2r (
    .rq2_wptr(rq2_wptr),
    .wptr(wptr),
    .rclk(fifoIntf.rclk),
    .rrst_n(fifoIntf.rrst_n)
  );

  rptr_empty rptr_empty (
    .rempty(fifoIntf.rempty),
    .raddr(raddr),
    .rptr(rptr),
    .rptr2(fifoIntf.rptr2),
    .rq2_wptr(rq2_wptr),
    .rinc(fifoIntf.rinc),
    .rclk(fifoIntf.rclk),
    .rrst_n(fifoIntf.rrst_n)
  );

  wptr_full wptr_full (
    .wfull(fifoIntf.wfull),
    .waddr(waddr),
    .wptr(wptr),
    .wptr2(fifoIntf.wptr2),
    .wq2_rptr(wq2_rptr),
    .winc(fifoIntf.winc),
    .wclk(fifoIntf.wclk),
    .wrst_n(fifoIntf.wrst_n)
  );

endmodule


// FIFO memory buffer
module fifomem 
( output logic [DATASIZE-1:0] rdata,
  input  logic [DATASIZE-1:0] wdata,
  input  logic [ADDRSIZE-1:0] waddr, raddr,
  input  logic winc, wfull, wclk);

  // RTL Verilog memory model
  //localparam DEPTH = 1<<ADDRSIZE;
  //logic [DATASIZE-1:0] mem [0:DEPTH-1];
  assign rdata = mem[raddr];

  always @(posedge wclk)
    if (winc && !wfull)
      mem[waddr] <= wdata;



endmodule


// Read-domain to write-domain synchronizer
module sync_r2w 
( output logic [POINTERSIZE:0] wq2_rptr,
  input  logic [POINTERSIZE:0] rptr,
  input  logic wclk, wrst_n);

  logic [POINTERSIZE:0] wq1_rptr;

  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
    else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
endmodule


// Write-domain to read-domain synchronizer
module sync_w2r 
( output logic [POINTERSIZE:0] rq2_wptr,
  input  logic [POINTERSIZE:0] wptr,
  input  logic rclk, rrst_n);

  logic [POINTERSIZE:0] rq1_wptr;

  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
    else {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule



// Read pointer and empty generation logic
module rptr_empty
( output logic rempty,
  output  [ADDRSIZE-1:0] raddr,
  output logic [POINTERSIZE :0] rptr,
  output logic [POINTERSIZE :0] rptr2,
  input   [POINTERSIZE :0] rq2_wptr,
  input   rinc, rclk, rrst_n);

  logic [POINTERSIZE:0] rbin;
  logic [POINTERSIZE:0] rgraynext, rbinnext;

  //-------------------

  // GRAYSTYLE2 pointer
  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) begin
{rbin, rptr} <= 0;
rptr2 <= 0;
end
    else begin
{rbin ,rptr}  <= {rbinnext, rgraynext};
rptr2 <= raddr;
end
  // Memory read-address pointer (okay to use binary to address memory)
  assign raddr = rbin[POINTERSIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  //---------------------------------------------------------------
  // FIFO empty when the next rptr == synchronized wptr or on reset
  //---------------------------------------------------------------
  assign rempty_val = (rgraynext == rq2_wptr);

  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rempty <= 1'b1;
    else rempty <= rempty_val;
endmodule


// Write pointer and full generation
module wptr_full
( output logic wfull,
  output  [ADDRSIZE-1:0] waddr,
  output logic [POINTERSIZE :0] wptr,
  output logic [POINTERSIZE :0] wptr2,
  input   [POINTERSIZE :0] wq2_rptr,
  input   winc, wclk, wrst_n);

  logic [POINTERSIZE:0] wbin;
  wire [POINTERSIZE:0] wgraynext, wbinnext;

  // GRAYSTYLE2 pointer
  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) begin 
{wbin, wptr} <= 0;
wptr2 <=0;
end
    else begin
{wbin,wptr} <= {wbinnext, wgraynext};
wptr2 <= wgraynext;
end
  // Memory write-address pointer (okay to use binary to address memory)
  assign waddr = wbin[POINTERSIZE-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  //------------------------------------------------------------------
  // Simplified version of the three necessary full-tests:
  // assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
  // (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
  // (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
  //------------------------------------------------------------------
  assign wfull_val = (wgraynext=={~wq2_rptr[POINTERSIZE:POINTERSIZE-1],
								   wq2_rptr[POINTERSIZE-2:0]});

  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wfull <= 1'b0;
    else wfull <= wfull_val;
endmodule

