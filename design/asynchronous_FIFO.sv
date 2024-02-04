//
//
//


import definitions::*;

`timescale 1ns/100ps;

module Asynch_FIFO (	output logic wfull, wack, 
  			output logic rempty, rack,
  			output logic [DATASIZE-1:0] rdata,
  			input  logic [DATASIZE-1:0] wdata,
  			input  logic wclk, wrst_n, wen,
  			input  logic rclk, rrst_n, ren);


  logic [ADDRSIZE-1:0] wptr, rptr, wq1_rptr, rq1_wptr;
  logic winc, rinc, rinc_o, winc_o;

assign rq1_wptr = 0;
assign wq1_rptr = 0;

  sync_r2w sync_r2w (.*); 
  sync_w2r sync_w2r (.*);
  fifomem fifomem (.*);
  fifo_ack fifo_ack(.*);

assign rinc = rinc_o ? 0 :1;
assign winc = winc_o ? 0 :1;
assign wptr = rq1_wptr;
assign rptr = wq1_rptr;

endmodule
