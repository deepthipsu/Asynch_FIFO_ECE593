

import definitions::*;

`timescale 1ns/100ps;

// Read-domain to write-domain synchronizer
module sync_r2w 
( output logic [ADDRSIZE-1:0] wq1_rptr,
  output logic inc_o,
  input  logic [ADDRSIZE-1:0] rptr,
  input  logic inc, wclk, wrst_n);
 
  logic [ADDRSIZE:0]rptr_i;

  always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wq1_rptr <= 0;
    else begin
	  wq1_rptr <= rptr_i;
	  inc_o <= 1;
    end

  assign rptr_i = inc ? rptr + 1 : rptr;

endmodule


module sync_r2w_tb;

logic [ADDRSIZE-1:0] wq1_rptr;
logic inc_o;
logic [ADDRSIZE-1:0] rptr;
logic inc, wclk, wrst_n;

sync_r2w sync_r2w(.*);

initial
begin
inc = 0;
rptr = 10'd1023;
wrst_n = 1;
wclk = 0;
#3 inc = 1;
#1 rptr = wq1_rptr;
end

always
begin
#1 wclk = ~wclk;

end

initial
begin
$monitor($time, "rptr = %d, wq1_rptr = %d, inc = %b, inc_o = %b", rptr, wq1_rptr, inc, inc_o);
#100 $stop;
end

endmodule