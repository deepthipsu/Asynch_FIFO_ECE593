//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-22-24
// Description: UVM item_seq for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// UVM testbench architecture help from https://verificationguide.com/uvm/uvm-testbench-architecture/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



import definitions::*;
import uvm_pkg::*; 

class fifo_sequence_item extends uvm_sequence_item;
  //Utility and Field macros
`include "uvm_macros.svh"
// data and control fields
  logic [DATASIZE-1:0] rdata;
   logic wfull;
   logic rempty;
  rand logic [DATASIZE-1:0] wdata;
   bit winc, wrst_n;
   bit rinc, rrst_n;
  logic [ADDRSIZE :0] rptr2, wptr2;
  rand int transactionID;
  `uvm_object_utils_begin(fifo_sequence_item)
    `uvm_field_int(rdata,UVM_ALL_ON)
    `uvm_field_int(wfull,UVM_ALL_ON)
    `uvm_field_int(rempty,UVM_ALL_ON)
    `uvm_field_int(winc,UVM_ALL_ON)
    `uvm_field_int(rinc,UVM_ALL_ON)
    `uvm_field_int(wrst_n,UVM_ALL_ON)
    `uvm_field_int(rrst_n,UVM_ALL_ON)
    `uvm_field_int(rptr2,UVM_ALL_ON)
    `uvm_field_int(wptr2,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
   `uvm_field_int(transactionID,UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name = "fifo_sequence_item");
    super.new(name);
  endfunction
endclass: fifo_sequence_item
