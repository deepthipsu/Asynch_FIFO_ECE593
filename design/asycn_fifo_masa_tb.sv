//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-09-24
// Description: Asynchronous FIFO design in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
//////////////////////////////////////////////////////////

import definitions::*;
module tb_fifo;

  // Signals
logic [DATASIZE-1:0] rdata;
logic wfull;
logic rempty;
logic [DATASIZE-1:0] wdata;
logic winc, wclk, wrst_n;
logic rinc, rclk, rrst_n;


  // Instantiate the FIFO Memory module
 // fifo1 FIFO_inst (.*);
  fifo FIFO_inst (.*);

  // Clock Generation
  initial begin
    wclk = 0;
    rclk = 0;

    // Toggle clocks every wclk=2 and rclk=4.4 time units respectively
fork
    forever #1 wclk = ~wclk;
    forever #2.22 rclk = ~rclk;
join
  end

  // Stimulus
initial begin
winc = 1'b0;
wdata = 1'b0;
wrst_n = 1'b0;
rinc = 1'b0;
//rdata = 1'b0;
rrst_n = 1'b0;
#1; 
wrst_n = 1'b1;
rrst_n = 1'b1;
winc = 1;
end	
 
logic [1:0] write_count = 0; // write idle cyle is 2
logic [1:0] read_count = 0; // read idle cycle is 1
logic [10:0] burst_count = 0; // 2^10 = 1024 

always @ (posedge wclk) begin
if (winc && !wfull) begin
if (write_count == WRITE_PERIOD) begin
wdata <= $random;
write_count <= 0;
end
else begin
write_count <= write_count +1;
end
end
end

always @ (posedge rclk) begin
if (rempty) begin
read_count <= 0;
end
else if (read_count == READ_PERIOD) begin
rinc =1;
read_count <= 0;
end
else begin
read_count <= read_count +1;
//rinc =0;
end
end

/*
always @ (posedge wclk) begin
if (winc && !wfull && write_count == WRITE_PERIOD) begin
if (burst_count == BURST_LENGTH -1) begin
burst_count <= 0;
end
else begin
burst_count <= burst_count +1;
end
end
end
*/

endmodule
