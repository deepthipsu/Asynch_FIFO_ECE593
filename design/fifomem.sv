

import definitions::*;

`timescale 1ns/100ps;

// FIFO memory buffer
module fifomem 
( output logic [DATASIZE-1:0] rdata,
  input  logic [DATASIZE-1:0] wdata,
  input  logic [ADDRSIZE-1:0] wptr, rptr,
  input  logic wack, wclk, wfull,
  input  logic rack, rclk, remty,
  output  logic rinc, winc);


  localparam DEPTH = 1<<ADDRSIZE;
  logic [DATASIZE-1:0] mem [0:DEPTH-1];

  always@(posedge rclk)
begin
  rdata <= (rack & ~remty) ? mem[rptr] : rdata;
  rinc <= (rack & ~remty) ? rinc+1 : rinc;
  mem[rptr] <= 0;
end

  always @(posedge wclk)
begin
  mem[wptr] <= (wack & ~wfull) ? wdata : mem[wptr];
  winc <= (wack & ~wfull) ? winc+1 : winc;
end

endmodule
