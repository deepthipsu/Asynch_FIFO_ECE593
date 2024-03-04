//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-10-24
// Description: Definitions for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// class based testbench help from: https://verificationguide.com/systemverilog-examples/systemverilog-testbench-example-adder-2/
//////////////////////////////////////////////////////////


package definitions;
//import uvm_pkg::*;
parameter ADDRSIZE = 10;
parameter DATASIZE = 8;
parameter POINTERSIZE = 8;
parameter DEPTH = 512;
parameter WRITE_PERIOD = 2; // Number of clock cycles between successive writes
parameter READ_PERIOD = 1; // Number of clock cycles between successive reads
parameter BURST_LENGTH = 1024; // Burst length
    int write_count = 0; // write idle cyle is 2
    int read_count = 0; // read idle cycle is 1
    int burst_count = 0; // 2^10 = 1024 
    int repeat_counts = 15;
//`include "transaction.sv"
//`include "generator.sv"
//`include "driver.sv"
logic [DATASIZE-1:0] mem [0:DEPTH-1];

//`include "fifoInterface.sv"
endpackage
