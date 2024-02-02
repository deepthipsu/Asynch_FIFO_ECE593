
import definitions::*;

`timescale 1ns/100ps;

// Write-domain to read-domain synchronizer
module sync_w2r 
( output logic [ADDRSIZE:0] rq1_wptr,
  input  logic [ADDRSIZE:0] wptr,
  input  logic rclk, rrst_n);

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rq1_wptr <= 0;
    else rq1_wptr <= wptr + 1;
endmodule
