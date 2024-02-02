

import definitions::*;

`timescale 1ns/100ps;

// Read-domain to write-domain synchronizer
module sync_r2w 
( output logic [ADDRSIZE:0] wq1_rptr,
  input  logic [ADDRSIZE:0] rptr,
  input  logic wclk, wrst_n);


  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wq1_rptr <= 0;
    else wq1_rptr <= rptr + 1;
endmodule