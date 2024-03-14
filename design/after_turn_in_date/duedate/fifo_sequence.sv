
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class fifo_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_sequence)
fifo_sequence_item req;
  //Constructor
  function new(string name = "fifo_sequence");
    super.new(name);
    //`uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  req = fifo_sequence_item::type_id::create("req");
  endfunction
  virtual task body();
   // `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
repeat(repeat_counts) begin  
	start_item(req);    
	//void'(req.randomize());
	req.wrst_n = 1'b0;
	req.rrst_n = 1'b0;
	req.wdata = 1'bx; 
	finish_item(req);
end
  endtask: body
endclass: fifo_sequence