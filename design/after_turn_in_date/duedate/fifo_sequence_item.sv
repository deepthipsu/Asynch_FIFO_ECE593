//////////////////////////////////////////////////////////
// Author: Masaaki Ishii (ishii@pdx.edu)
// Date: 02-22-24
// Description: UVM item_seq for asynchronous FIFO in SystemVerilog translated from 
// Verilog to SystemVerilog, based on Cliff Cumming's Simulation and Synthesis Techniques for Asynchronous FIFO Design
// http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// UVM testbench architecture help from https://verificationguide.com/uvm/uvm-testbench-architecture/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



import definition::*;
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
   int transactionID;


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

	//constraint rdata_c {rdata >= 0; rdata <=256;}
	//constraint wdata_c {wdata >= 0; wdata <=256;}
	//constraint full_and_empty_c {wfull != rempty;}
	constraint burst_limit_c { BURST_LENGTH <= 1024;}
 /*
  function new(string name = "fifo_sequence_item");
    super.new(name);
	rdata = 'bx;
	wdata = 'bx;
	wfull = 'bx;
	rempty = 'bx;
	rinc = 'bx;
	winc = 'bx;
  endfunction
*/
endclass: fifo_sequence_item
