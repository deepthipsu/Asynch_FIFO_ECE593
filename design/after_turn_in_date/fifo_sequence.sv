////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class fifo_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_sequence)
  
  typedef fifo_sequence_item fifo_item_t;

  function new(string name="fifo_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    fifo_item_t item;
    repeat (repeat_counts) begin
    item = fifo_item_t::type_id::create("item");
      start_item(item);
      
      item.reset();
      
      finish_item(item);
    end
  endtask
endclass: fifo_sequence

class fifo_write_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_write_sequence)
  
  typedef fifo_sequence_item fifo_item_t;
 
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "fifo_write_sequence");
    super.new(name);
   // `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction

  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  virtual task body();
   // `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
	fifo_item_t item;
	repeat(repeat_counts) begin
		item = fifo_item_t::type_id::create("");
    		start_item(item);
		assert(item.randomize() with {rinc == 1'b0;});
		finish_item(item);
        end
  endtask: body

endclass: fifo_write_sequence 


class fifo_read_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_read_sequence)
  
  typedef fifo_sequence_item fifo_item_t;
 
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "fifo_read_sequence");
    super.new(name);
   // `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction

  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
 virtual task body();
   // `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
	fifo_item_t item;
	repeat(repeat_counts) begin
		item = fifo_item_t::type_id::create("item");
    		start_item(item);
		assert(item.randomize() with {winc == 1'b0;});
		finish_item(item);
        end
  endtask: body
endclass: fifo_read_sequence