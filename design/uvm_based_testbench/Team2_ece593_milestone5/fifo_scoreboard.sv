/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class fifo_scoreboard extends uvm_test;
  `uvm_component_utils(fifo_scoreboard)
  
  uvm_analysis_imp #(fifo_sequence_item, fifo_scoreboard) scoreboard_port;
  
  fifo_sequence_item transactions[$];
  

//--------------------------------
// Coverage
//--------------------------------
fifo_sequence_item fifoTBintf;
covergroup cov_group;

      write: coverpoint fifoTBintf.wdata {
        // bins zeros = {'h00};
         //bins others= {['h01:'hFE]};
         //bins ones  = {'hFF};
	 bins allBitsIn = {[8'b00000000:8'b11111111]};
      }


      read: coverpoint fifoTBintf.rdata {
      //   bins zeros = {'h00};
        // bins others= {['h01:'hFE]};
         //bins ones  = {'hFF};
	 bins allBitsOut = {[8'b00000000:8'b11111111]};
      }

wrst: coverpoint fifoTBintf.wrst_n {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }

      rrst: coverpoint fifoTBintf.rrst_n {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }
      winc: coverpoint fifoTBintf.winc {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }

      rinc: coverpoint fifoTBintf.rinc {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }
      wfull: coverpoint fifoTBintf.wfull {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }

      rempty: coverpoint fifoTBintf.rempty {
         bins zeros = {'b0};
         bins ones  = {'b1};
      }


endgroup
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
cov_group = new;
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)   
  endfunction: connect_phase
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write(fifo_sequence_item item);
    transactions.push_back(item);
  endfunction: write 
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_HIGH)
   
    forever begin
      /*
      // get the packet
      // generate expected value
      // compare it with actual value
      // score the transactions accordingly
      */

      fifo_sequence_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);
	  
fifoTBintf = curr_trans;
     cov_group.sample();

    end  
  endtask: run_phase
  //--------------------------------------------------------
  //Compare : Generate Expected Result and Compare with Actual
  //--------------------------------------------------------
  task compare(fifo_sequence_item curr_trans);
    logic [8:0] expected;
    logic [8:0] actual;
actual = curr_trans.rdata;
expected = mem[curr_trans.rptr2];   

if( curr_trans.rinc) begin
	//if(mem[curr_trans.rptr2] != curr_trans.rdata)    
	if(actual != expected) begin
      `uvm_error("COMPARE", $sformatf("Transaction failed! ACT=%d, EXP=%d", actual, expected))
    end
    else begin
      // Note: Can display the input and op_code as well if you want to see what's happening
      `uvm_info("COMPARE", $sformatf("Transaction Passed! ACT=%d, EXP=%d,  TransactionID =%d", actual, expected, curr_trans.rptr2), UVM_LOW)
    end
    end
//end
  endtask: compare
endclass: fifo_scoreboard