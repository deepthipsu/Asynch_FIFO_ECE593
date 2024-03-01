//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Driver class for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////

import definitions::*;

class driver;
    int no_transactions = 0;

    logic [1:0] write_count = 0; // write idle cyle is 2
    logic [1:0] read_count = 0; // read idle cycle is 1
    logic [10:0] burst_count = 0; // 2^10 = 1024 

    virtual intf vif;

    mailbox gen2driv;
    transaction trans;

    function new(virtual intf vif, mailbox gen2driv);
        this.vif = vif;
        this.gen2driv = gen2driv;
    endfunction

    task reset;
        $display("[ DRIVER ] ----- Reset Started -----");
        vif.wdata <= 0;
        vif.rdata <= 0;
        vif.winc <= 0;
        vif.rinc <= 0;
        vif.wrst_n <= 0;
        vif.rrst_n <= 0; 
        #10;
        vif.wrst_n <= 1;
        vif.rrst_n <= 1;
        vif.winc <= 1;   
        vif.rinc <= 1;  
        //wait(!vif);
        $display("[ DRIVER ] ----- Reset Ended   -----");
    endtask

    task main;
    //    $display("[ DRIVER ] ----- in main  -----");
        forever begin
//gen2driv.get(trans);
            @( posedge vif.wclk) begin
                //if (vif.winc && !vif.wfull) begin
vif.winc <= 1;
                if (!vif.wfull) begin
                    if (write_count == WRITE_PERIOD) begin
                        gen2driv.get(trans);
                        vif.wdata <= trans.wdata;
                        vif.winc <= 1;
                        write_count <= 0;
                       // no_transactions = no_transactions +1;
                        burst_count = burst_count +1;
                        $display("---burst count = %0d", burst_count);
                       // $display("---transactions = %0d", no_transactions);
                            if (burst_count == BURST_LENGTH -1) begin
				$display("Maximum burst count of reached %0d", burst_count);
                                burst_count <= 0;
                            end 
                    end
                    else begin
                        write_count <= write_count +1;
                        vif.winc <= 0;
                    end
                end
                end
            end    
    endtask

    task main1;
   // $display("[ DRIVER ] ----- in main1  -----");
        forever begin
            @( posedge vif.rclk) begin
                if (vif.rempty) begin
                    read_count <= 0;
                    //vif.rinc =1;
                end
                else if (read_count == READ_PERIOD) begin
                    vif.rinc =1;
                    read_count <= 0;
                end
                else begin
                    read_count <= read_count +1;
                    vif.rinc =0;
                end
            end
        end
    endtask
endclass
