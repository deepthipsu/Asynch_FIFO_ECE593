



import definitions::*;

`timescale 1ns/100ps;

// FIFO Acknowledgement
module fifo_ack
( output logic rack, remty,
  output logic wack, wfull,
  input logic rptr, ren, ridle,
  input  logic wptr, wen, 
  input logic [1:0]widle);

logic [ADDRSIZE-1:0] size;

always
begin
// Check if any read or write requests received
if((wen & ~wack) | (ren & ~rack))
	begin
// Calculate fifo space available
	size = (rptr > wptr) ? (rptr-wptr) : (10'd1024 - wptr + rptr);
	if(size == 1024) begin remty = 1; wfull = 0; end
	else if (size == 0) begin wfull = 1; remty = 0; end
	else begin remty = 0; wfull = 0; end

// Send corresponding acknowledgements
	if(wen & ~wack)
		begin
		if(rack)
			begin
			case({widle,ridle})
			2'b00:	wack = (size >= 10'd560) ? 1 : 0;
			2'b01:	wack = (size >= 10'd792) ? 1 : 0;
			2'b10:	wack = (size >= 10'd95)  ? 1 : 0;
			2'b11:	wack = (size >= 10'd560) ? 1 : 0;
			3'b100:	wack = (size >= 10'd1)   ? 1 : 0;
			3'b101:	wack = (size >= 10'd327) ? 1 : 0;		
			endcase
			end
		else
			wack = remty ? 1 : 0;
		end
	else
		begin
		if(wack)
			begin
			if({widle,ridle} == 3'b100)
				rack = (size <= 750) ? 1 : 0;
			else  rack = 1;
			end
		else
			rack = wfull ? 1 : 0;
		end
	end
else
	rack = rack;

end

endmodule