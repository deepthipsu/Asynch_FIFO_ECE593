//////////////////////////////////////////////////////////////////////////////////////////////

class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_environment env;
  fifo_sequence reset_seq;
 fifo_write_sequence wtest_seq;
  fifo_read_sequence rtest_seq;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

    env = fifo_environment::type_id::create("env", this);
     wtest_seq = fifo_write_sequence::type_id::create("wtest_seq");
	rtest_seq = fifo_read_sequence::type_id::create("rtest_seq");
  endfunction: build_phase

  //--------------------------------------------------------
  //End of Elaboration Phase
  //--------------------------------------------------------
virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction: end_of_elaboration_phase

  //--------------------------------------------------------
  //Report Phase
  //--------------------------------------------------------
virtual function void report_phase(uvm_phase phase);
	uvm_report_server svr;
	super.report_phase(phase);
	svr = uvm_report_server::get_server();
	if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
		`uvm_info(get_type_name(),"===============ECE593 TEST FAILED================",UVM_NONE)
	end
	else begin
		`uvm_info(get_type_name(),"===============ECE593 TEST PASSED================",UVM_NONE)
	end
endfunction: report_phase
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)
    phase.raise_objection(this);
    //reset_seq
    //reset_seq = fifo_sequence::type_id::create("reset_seq");
    //reset_seq.start(env.wagnt.wseqr);
    //reset_seq.start(env.ragnt.rseqr);
    //#10;
//phase.raise_objection(this);
    repeat(repeat_counts) begin
      //test_seq
	fork
      wtest_seq.start(env.wagnt.wseqr);
	rtest_seq.start(env.ragnt.rseqr);
join_any
    end 
    phase.drop_objection(this);
  endtask: run_phase
endclass: fifo_test

/*
class fifo_test_wfull extends uvm_test;
  `uvm_component_utils(fifo_test_wfull)

  fifo_environment env;
  fifo_sequence reset_seq;
  write_full_sequence wtest_seq;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_test_wfull", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)
    env = fifo_environment::type_id::create("env", this);
     wtest_seq = write_full_sequence::type_id::create("wtest_seq");
  endfunction: build_phase
  //--------------------------------------------------------
  //End of Elaboration Phase
  //--------------------------------------------------------
virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction: end_of_elaboration_phase
  //--------------------------------------------------------
  //Report Phase
  //--------------------------------------------------------
virtual function void report_phase(uvm_phase phase);
	uvm_report_server svr;
	super.report_phase(phase);
	svr = uvm_report_server::get_server();
	if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
		`uvm_info(get_type_name(),"===============ECE593 TEST FAILED================",UVM_NONE)
	end
	else begin
		`uvm_info(get_type_name(),"===============ECE593 TEST PASSED================",UVM_NONE)
	end
endfunction: report_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)
    phase.raise_objection(this);
    //reset_seq
    //reset_seq = fifo_sequence::type_id::create("reset_seq");
    //reset_seq.start(env.wagnt.wseqr);
    //reset_seq.start(env.ragnt.rseqr);
    //#10;
//phase.raise_objection(this);
    repeat(repeat_counts) begin
      //test_seq
	fork
      wtest_seq.start(env.wagnt.wseqr);
join_any
    end
    phase.drop_objection(this);
  endtask: run_phase
endclass: fifo_test_wfull
*/

/*
class fifo_test_rempty extends uvm_test;
  `uvm_component_utils(fifo_test_rempty)

  fifo_environment env;
  fifo_sequence reset_seq;
  //write_full_sequence wtest_seq;
  read_empty_sequence rtest_seq;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_test_rempty", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

    env = fifo_environment::type_id::create("env", this);
     rtest_seq = read_empty_sequence::type_id::create("rtest_seq");
  endfunction: build_phase
  //--------------------------------------------------------
  //End of Elaboration Phase
  //--------------------------------------------------------
virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction: end_of_elaboration_phase
  //--------------------------------------------------------
  //Report Phase
  //--------------------------------------------------------
virtual function void report_phase(uvm_phase phase);
	uvm_report_server svr;
	super.report_phase(phase);
	svr = uvm_report_server::get_server();
	if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
		`uvm_info(get_type_name(),"===============ECE593 TEST FAILED================",UVM_NONE)
	end
	else begin
		`uvm_info(get_type_name(),"===============ECE593 TEST PASSED================",UVM_NONE)
	end
endfunction: report_phase
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase 
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)
    phase.raise_objection(this);
    //reset_seq
    //reset_seq = fifo_sequence::type_id::create("reset_seq");
    //reset_seq.start(env.wagnt.wseqr);
    //reset_seq.start(env.ragnt.rseqr);
    //#10;
//phase.raise_objection(this);
    repeat(repeat_counts) begin
      //test_seq
	fork
      //wtest_seq.start(env.wagnt.wseqr);
	  rtest_seq.start(env.ragnt.rseqr);
join_any
    end
    phase.drop_objection(this);
  endtask: run_phase
endclass: fifo_test_rempty
*/