import definitions::*;
module tb_fifo;

intf fifoTBintf(); // create interface object


  // Instantiate the FIFO Memory module
 // fifo1 FIFO_inst (.*);
  fifo FIFO_inst (fifoTBintf.DUT); //instantiate the DUT, pass the TB modport to it

  // Clock Generation
  initial begin
    fifoTBintf.wclk = 0;
    fifoTBintf.rclk = 0;

    // Toggle clocks every wclk=2 and rclk=4.4 time units respectively
fork
    forever #1 fifoTBintf.wclk = ~fifoTBintf.wclk;
    forever #2.22 fifoTBintf.rclk = ~fifoTBintf.rclk;
join
  end

  // Stimulus
initial begin
fifoTBintf.winc = 1'b0;
fifoTBintf.wdata = 1'b0;
fifoTBintf.wrst_n = 1'b0;
fifoTBintf.rinc = 1'b0;
//rdata = 1'b0;
fifoTBintf.rrst_n = 1'b0;
#1; 
fifoTBintf.wrst_n = 1'b1;
fifoTBintf.rrst_n = 1'b1;
fifoTBintf.winc = 1;
end	
 
logic [1:0] write_count = 0; // write idle cyle is 2
logic [1:0] read_count = 0; // read idle cycle is 1
logic [10:0] burst_count = 0; // 2^10 = 1024 

always @ (posedge fifoTBintf.wclk) begin
if (fifoTBintf.winc && !fifoTBintf.wfull) begin
if (write_count == WRITE_PERIOD) begin
fifoTBintf.wdata <= $random;
write_count <= 0;
end
else begin
write_count <= write_count +1;
end
end
end

always @ (posedge fifoTBintf.rclk) begin
if (fifoTBintf.rempty) begin
read_count <= 0;
end
else if (read_count == READ_PERIOD) begin
fifoTBintf.rinc =1;
read_count <= 0;
end
else begin
read_count <= read_count +1;
//rinc =0;
end
end


always @ (posedge fifoTBintf.wclk) begin
if (fifoTBintf.winc && !fifoTBintf.wfull && write_count == WRITE_PERIOD) begin
if (burst_count == BURST_LENGTH -1) begin
burst_count <= 0;
#1000;
end
else begin
burst_count <= burst_count +1;
end
end
end


endmodule
