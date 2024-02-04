`timescale 1ns/100ps
import definitions::*;
module tb;

  // Signals
  logic [DATASIZE-1:0] rdata;
  logic [DATASIZE-1:0] wdata;
 
  logic wack, wrst_n, wclk, wfull, wen, ren;
  logic rack, rrst_n, rclk, remty;
  			 logic ridle;
			 logic [1:0]widle;

  // Instantiate the FIFO Memory module
  asynchronous_FIFO FIFO_inst (.*);

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
	 wen ='0;
	 ren = '0;
	 wrst_n='0;
	 rrst_n =0;
	 wdata ='0;
	 //rdata ='0;
	 wen =1;

end	 


always
begin
	 if(wack == 1);
	 begin
	 for(int i=0; i< 1024; i = i+1) 
		begin
		#1;
		wdata <= i;
		end
		wen =1'd0;
	 $monitor("Time=%0t wdata = %0d mem[wptr] = %0d winc=%0d rinc=%0d", $time, wdata, FIFO_inst.wptr, FIFO_inst.rptr, FIFO_inst.winc, FIFO_inst.rinc);
	 end

  end

endmodule
