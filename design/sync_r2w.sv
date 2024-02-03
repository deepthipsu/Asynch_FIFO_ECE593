

import definitions::*;

`timescale 1ns/100ps;

// Read-domain to write-domain synchronizer
module sync_r2w 
( output logic [ADDRSIZE:0] wq1_rptr,
  output logic inc_o,
  input  logic [ADDRSIZE:0] rptr,
  input  logic inc, wclk, wrst_n);
 
  logic [ADDRSIZE:0]rptr_i;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wq1_rptr <= 0;
    else begin
	  wq1_rptr <= rptr_i;
	  inc_o <= 0;
    end

  assign rptr_i = inc ? rptr + 1 : rptr;

endmodule