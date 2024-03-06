
  class fifo_write_sequence extends fifo_sequence;
  `uvm_object_utils(fifo_write_sequence)
  
//parameter repeat_counts = 10;
  fifo_sequence_item item;
  fifo_sequence_item item1 = null;
 
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "fifo_write_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
	item = fifo_sequence_item::type_id::create("item");

repeat(repeat_counts/2) begin
    //item = fifo_sequence_item::type_id::create("item");
    start_item(item);
	//item.rinc = 1'b0;
	//item.rptr2 = 1'b0;
//item.wrst_n = 1'b1;
 //       item.rrst_n = 1'b1; 
    assert(item.randomize() with {rinc == 1'b0; });
    finish_item(item);
        end

/*
repeat(repeat_counts/2) begin
    //item = fifo_sequence_item::type_id::create("item");
    start_item(item);
	//item.rinc = 1'b0;
	//item.rptr2 = 1'b0;
item.wrst_n = 1'b0;
        item.rrst_n = 1'b0; 
    //assert(item.randomize() with {rinc == 1'b0;});
    finish_item(item);
        end*/

  endtask: body

endclass: fifo_write_sequence 

/*
class fifo_read_sequence extends fifo_sequence;
  `uvm_object_utils(fifo_read_sequence)
  fifo_sequence_item item;
 // parameter repeat_counts = 10;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "fifo_read_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction 
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
repeat(repeat_counts) begin
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with {winc == 1'b0;});
    finish_item(item);
        end
  endtask: body
endclass: fifo_read_sequence 
*/


//write full Sequence
class write_full_sequence extends fifo_sequence;
  `uvm_object_utils(write_full_sequence)
//parameter repeat_counts = 512;
  fifo_sequence_item item;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "write_full_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Starting Write-Full Sequence", UVM_HIGH)
    // Fill the FIFO to capacity
    repeat(repeat_counts) begin
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { rinc == 1'b0; });
      finish_item(item);
    end
    // Attempt to write to a full FIFO
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with { rinc == 1'b0; });
    finish_item(item);
  endtask
endclass: write_full_sequence 


/*
//read empty Sequence
class read_empty_sequence extends fifo_sequence;
  `uvm_object_utils(read_empty_sequence)
  fifo_sequence_item item;
  parameter repeat_counts = 513;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "read_empty_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside read_empty_sequence Constructor!", UVM_HIGH)
  endfunction
   //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Starting Read-Empty Sequence", UVM_HIGH)
    // Attempt to read from an empty FIFO
	    repeat(repeat_counts) begin
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with { winc == 1'b0; });
    finish_item(item);
	end
	// Attempt to read from a empty FIFO
    item = fifo_sequence_item::type_id::create("item");
    start_item(item);
    assert(item.randomize() with { winc == 1'b0; });
    finish_item(item);
  endtask
endclass: read_empty_sequence 


//sequential write and read 
class sequential_write_read_sequence extends fifo_sequence;
  `uvm_object_utils(sequential_write_read_sequence)
   fifo_sequence_item item;
  parameter repeat_counts = 100;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "sequential_write_read_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Sequential Write and Read Constructor!", UVM_HIGH)
  endfunction
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Starting Sequential Write and Read Sequence", UVM_HIGH)
    repeat(repeat_counts) begin
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { rinc == 1'b0; });
      finish_item(item);
      // Delay before reading
      #10;
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { winc == 1'b0; });
      finish_item(item);
    end
  endtask
endclass: sequential_write_read_sequence


//simultaneous write and read Sequence
class simultaneous_write_read_sequence extends fifo_sequence;
  `uvm_object_utils(simultaneous_write_read_sequence)
  
  fifo_sequence_item item;
  parameter repeat_counts = 100;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "simultaneous_write_read_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("TEST_SEQ", "Starting Simultaneous Write and Read Sequence", UVM_HIGH)
    repeat(repeat_counts) begin
      item = fifo_sequence_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with { rinc == 1'b0; winc == 1'b0; });
      finish_item(item);
    end
  endtask
endclass: simultaneous_write_read_sequence


//reset condition
class reset_behavior_sequence extends fifo_sequence;
  task body();
    `uvm_info("SEQ", "Starting Reset Behavior Sequence", UVM_HIGH)
    // Assert reset signal
    //assert(env.wagnt.wdrv.drive_reset(req) && env.ragnt.rdrv.drive_reset(req));
    // Delay to allow reset to take effect
    #10;
  endtask
endclass: reset_behavior_sequence

*/
