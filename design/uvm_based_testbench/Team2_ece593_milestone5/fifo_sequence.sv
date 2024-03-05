
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class fifo_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_sequence)
fifo_sequence_item req;
  //Constructor
  function new(string name = "fifo_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  virtual task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
    req = fifo_sequence_item::type_id::create("req");
	start_item(req);    
	  if(!req.randomize()) $fatal("randomization failed");
	finish_item(req);
  endtask: body
endclass: fifo_sequence