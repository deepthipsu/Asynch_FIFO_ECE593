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

  time	t; //store simulation time
  
  logic [DATASIZE-1:0] rdata;
  logic wfull;
  logic rempty;
  rand logic [DATASIZE-1:0] wdata;
  rand bit winc, wrst_n;
  rand bit rinc, rrst_n;
  logic [ADDRSIZE :0] rptr2, wptr2;
  
  `uvm_object_utils_begin(fifo_sequence_item)
    `uvm_field_int(rdata,UVM_ALL_ON)
    `uvm_field_int(wfull,UVM_ALL_ON)
    `uvm_field_int(rempty,UVM_ALL_ON)
    `uvm_field_int(winc,UVM_ALL_ON)
    `uvm_field_int(rinc,UVM_ALL_ON)
    `uvm_field_int(wrst_n,UVM_ALL_ON)
    `uvm_field_int(rrst_n,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="fifo_sequence_item");
    super.new(name);
    t	= 		0;
    rdata = 	{DATASIZE{1'bx}};
    wfull = 	1'bx;
    rempty = 	1'bx;
    wdata = 	{DATASIZE{1'b0}};
    winc = 		1'b0;
    wrst_n = 	1'b1;
    rinc = 		1'b0;
    rrst_n = 	1'b1;
  endfunction
  
  virtual function void do_copy(uvm_object rhs);
    fifo_sequence_item rhs_cast;
    //check if child class is capable with parent class
    if (!$cast(rhs_cast, rhs)) begin
      uvm_report_error("do_copy:", "cast failed");
      return;
    end
    
    super.do_copy(rhs);
    this.t	=			rhs_cast.t;
    this.rdata = 			rhs_cast.rdata;
    this.wfull = 			rhs_cast.wfull;
    this.rempty = 			rhs_cast.rempty;
    this.wdata = 			rhs_cast.wdata;
    this.winc = 			rhs_cast.winc;
    this.wrst_n = 			rhs_cast.wrst_n;
    this.rinc = 			rhs_cast.rinc;
    this.rrst_n = 			rhs_cast.rrst_n;
  endfunction
  
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fifo_sequence_item rhs_cast;
    
    if (!$cast(rhs_cast, rhs)) begin
      uvm_report_error("do_compare:", "cast failed");
      return 0;
    end
    
    return (super.do_compare(rhs, comparer) //compare parent attributes
            && (this.t == 		rhs_cast.t)
            && (this.rdata == 		rhs_cast.rdata)
            && (this.rdata == 		rhs_cast.rdata)
            && (this.wfull == 		rhs_cast.wfull)
            && (this.rempty == 		rhs_cast.rempty)
            && (this.wdata == 		rhs_cast.wdata)
            && (this.winc == 		rhs_cast.winc)
            && (this.wrst_n == 		rhs_cast.wrst_n)
            && (this.rinc == 		rhs_cast.rinc)
            && (this.rrst_n == 		rhs_cast.rrst_n)
           );
  endfunction
  
  virtual function string convert2string();
    string s = super.convert2string();
    
    $sformat(s, "%s\n 	TRANS INFO:", s);
    $sformat(s, "%s\n 	(time)	t: 		%0t", s, t);
    $sformat(s, "%s\n 	(out)	rdata: 	%x", s, rdata);
    $sformat(s, "%s\n 	(out)	wfull: 	%x", s, wfull);
    $sformat(s, "%s\n 	(out)	rempty:	%x", s, rempty);
    $sformat(s, "%s\n 	wdata: 	%x", s, wdata);
    $sformat(s, "%s\n 	winc: 	%x", s, winc);
    $sformat(s, "%s\n 	wrst_n: %x", s, wrst_n);
    $sformat(s, "%s\n 	rinc: 	%x", s, rinc);
    $sformat(s, "%s\n 	rrst_n: %x", s, rrst_n);
    
    return s;
  endfunction
  
  virtual function string wconvert2string();
    string s = super.convert2string();
    
    $sformat(s, "%s\n 	WRITE TRANS INFO:", s);
    $sformat(s, "%s\n 	(time)	t: 		%0t", s, t);
    $sformat(s, "%s\n 	(out)	wfull: 	%x", s, wfull);
    $sformat(s, "%s\n 			wdata: 	%x", s, wdata);
    $sformat(s, "%s\n 			winc: 	%x", s, winc);
    $sformat(s, "%s\n 			wrst_n: %x", s, wrst_n);
    
    return s;
  endfunction
  
  virtual function string rconvert2string();
    string s = super.convert2string();
    
    $sformat(s, "%s\n 	READ TRANS INFO:", s);
    $sformat(s, "%s\n 	(time)	t: 		%0t", s, t);
    $sformat(s, "%s\n 	(out)	rdata: 	%x", s, rdata);
    $sformat(s, "%s\n 	(out)	rempty: %x", s, rempty);
    $sformat(s, "%s\n 			rinc:	%x", s, rinc);
    $sformat(s, "%s\n 			rrst_n: %x", s, rrst_n);
    
    return s;
  endfunction
  
  function void reset();
    wrst_n = 1'b0;
   	rrst_n = 1'b0;
  endfunction
  
endclass
