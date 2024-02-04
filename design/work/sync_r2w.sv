

import definitions::*;

//`timescale 1ns/100ps;

// Read-domain to write-domain synchronizer
module sync_r2w 
( output logic [ADDRSIZE-1:0] wq1_rptr,
  output logic rinc_o,
  input  logic [ADDRSIZE-1:0] rptr,
  input  logic rinc, wclk, wrst_n);
 
  logic [ADDRSIZE:0]rptr_i;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wq1_rptr <= 0;
    else begin
	  wq1_rptr <= rptr_i;
	  rinc_o <= 1;
    end

  assign rptr_i = rinc ? rptr + 1 : rptr;

endmodule