`timescale 1ns / 1ps
import definitions::*;


module tb;
    // Clocks
    logic wclk;
    logic rclk;
    // FIFO interface signals
    logic [ADDRSIZE-1:0] waddr;
    logic [ADDRSIZE-1:0] raddr;
    logic [DATASIZE-1:0] wdata;
    logic winc;
    logic wrst_n;
    logic [ADDRSIZE:0] wptr;
    logic [ADDRSIZE:0] rptr;
    logic [ADDRSIZE:0] wq2_rptr;
    logic [ADDRSIZE:0] rq2_wptr;
    logic rempty;
    logic wfull;
    logic [DATASIZE-1:0] rdata;
    logic rinc;
    logic rrst_n;
    logic [ADDRSIZE:0] rptr2;
    logic [ADDRSIZE:0] wptr2;
    // Instantiate FIFO
    fifo dut (
        .wclk(wclk),
        .rclk(rclk),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .winc(winc),
        .wrst_n(wrst_n),
        .wptr(wptr),
        .rptr(rptr),
        .wq2_rptr(wq2_rptr),
        .rq2_wptr(rq2_wptr),
        .rempty(rempty),
        .wfull(wfull),
        .rdata(rdata),
        .rinc(rinc),
        .rrst_n(rrst_n),
        .rptr2(rptr2),
        .wptr2(wptr2)
    );
    // Clock generation
    initial begin
        wclk = 0;
        rclk = 0;
        forever begin
            #5 wclk = ~wclk;
        end
    end
    always #10 rclk = ~rclk;
    // Testbench stimulus
    initial begin
        // Reset signals
        wrst_n = 0;
        rrst_n = 0;
        #20 wrst_n = 1;
        #20 rrst_n = 1;
        // Write 10 entries to FIFO
        repeat (10) begin
            waddr = $random;
            wdata = $random;
            winc = 1;
            #10;
            winc = 0;
            #10;
        end
        // Read from FIFO
        repeat (10) begin
            raddr = $random;
            rinc = 1;
            #10;
            rinc = 0;
            #10;
        end
        // End simulation
        $finish;
    end
endmodule