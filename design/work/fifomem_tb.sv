`timescale 1ns/100ps
import definitions::*;
module tb;

  // Signals
  logic [DATASIZE-1:0] rdata;
  logic [DATASIZE-1:0] wdata;
  logic [ADDRSIZE-1:0] wptr, rptr;
  logic wack, wclk, wfull;
  logic rack, rclk, remty;
  logic rinc, winc;

  // Instantiate the FIFO Memory module
  fifomem fifomemory_instantiation (
    .rdata(rdata), .wdata(wdata),
    .wptr(wptr), .rptr(rptr),
    .wack(wack), .wclk(wclk), .wfull(wfull),
    .rack(rack), .rclk(rclk), .remty(remty),
    .rinc(rinc), .winc(winc)
  );

  // Clock Generation
  initial begin
    wclk = 0;
    rclk = 0;

    // Toggle clocks every wclk=2 and rclk=4.4 time units respectively
    forever #1 wclk = ~wclk;
    forever #2.2 rclk = ~rclk;
  end

  // Stimulus
 initial
  begin
    // Initialize signals
    wdata ='0;
    wptr = 4'h0;
    rptr = 4'h0;
    wack = 1'b0;
    winc =1'b0;
 
    // Write data to the FIFO
	for(int i=0; i< 1024; i = i+1) 
		begin
		#1;
		wack = 1'b1;
		wfull=1'b0;
		wdata <= i; 
		#1;
		wack =1'b0; 
		end
		
		
    #10 $finish;
  end

  // Display simulation results
 always @(posedge wclk)
 begin
     $monitor("Time=%0t wdata = %0d wptr=%0d rptr=%0d winc=%0d rinc=%0d", $time, wdata, wptr, rptr, winc, rinc);
  end

endmodule
