import definitions::*;
//`timescale 1ns/100ps

module tb;


  // Signals
  logic [ADDRSIZE:0] rptr;
  logic inc, wclk, wrst_n;
  logic [ADDRSIZE:0] wq1_rptr;
  logic inc_o;

  // Instantiate the module  
  sync_r2w sync_r2w(.*);


initial
begin
inc = 0;
rptr = 10'd1000;
wrst_n = 1;
wclk = 0;
@(posedge wclk);
inc = 1;
@(posedge wclk);
rptr = wq1_rptr;
end

always
begin
#1 wclk = ~wclk;

end

initial
begin
@(negedge wclk);
$monitor($time, "rptr = %d, wq1_rptr = %d, inc = %b, inc_o = %b", rptr, wq1_rptr, inc, inc_o);
#100 $stop;
end

endmodule

