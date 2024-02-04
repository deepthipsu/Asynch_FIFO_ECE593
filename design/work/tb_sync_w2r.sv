
import definitions::*;

module tb;

  // Signals
  logic [ADDRSIZE:0] wptr;
  logic inc, rclk, rrst_n;
  logic [ADDRSIZE:0] rq1_wptr;
  logic inc_o;

  // Instantiate the module
  sync_w2r dut_instantiation (.*);


  // Clock generation
  always
  begin
    #2.2 rclk = ~rclk;
  end

 
  initial 
  begin
    // Initialize inputs
	inc = 0;
    wptr = 10'd1000;
    rrst_n = 1;
	rclk=0;

    @(posedge rclk);
    inc = 1;
    @(posedge rclk);
	wptr = rq1_wptr;
	end
	
	initial 
	begin
	@(negedge rclk);
	$monitor($time, "wptr = %d, rq1_wptr = %d, inc = %b, inc_o = %b", wptr, rq1_wptr, inc, inc_o);
	#100 $stop;
	end
   

endmodule
