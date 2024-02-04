
import definitions::*;


// Write-domain to read-domain synchronizer
module sync_w2r 
( output logic [ADDRSIZE-1:0] rq1_wptr,
  output logic winc_o,
  input  logic [ADDRSIZE-1:0] wptr,
  input  logic winc, rclk, rrst_n);

 logic [ADDRSIZE:0]wptr_i;

  always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rq1_wptr <= 0; 
    else begin
	rq1_wptr <= wptr_i;
	winc_o <= 0;
    end

assign wptr_i = winc ? wptr + 1 : wptr;

endmodule