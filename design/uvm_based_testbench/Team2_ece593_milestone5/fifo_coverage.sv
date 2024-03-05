//--------------------------------
// Coverage
//--------------------------------
class fifo_coverage extends uvm_test; // #(fifo_sequence_item);
  `uvm_component_utils(fifo_coverage)
 uvm_analysis_imp #(fifo_sequence_item, fifo_coverage) coverage_port;
fifo_sequence_item transactions[$];
fifo_sequence_item fifoTBintf;
covergroup cov_group;
     write: coverpoint fifoTBintf.wdata {
     bins allBitsIn = {[8'b00000000:8'b11111111]};
     }
     read: coverpoint fifoTBintf.rdata {
     //  bins zeros = {'h00};
       // bins others= {['h01:'hFE]};
        //bins ones = {'hFF};
     bins allBitsOut = {[8'b00000000:8'b11111111]};
     }
wrst: coverpoint fifoTBintf.wrst_n {
        bins zeros = {'b0};
        bins ones = {'b1};
     }
     rrst: coverpoint fifoTBintf.rrst_n {
        bins zeros = {'b0};
        bins ones = {'b1};
     }
     winc: coverpoint fifoTBintf.winc {
        bins zeros = {'b0};
        bins ones = {'b1};
     }
     rinc: coverpoint fifoTBintf.rinc {
        bins zeros = {'b0};
        bins ones = {'b1};
     }
     wfull: coverpoint fifoTBintf.wfull {
        bins zeros = {'b0};
        bins ones = {'b1};
     }
     rempty: coverpoint fifoTBintf.rempty {
        bins zeros = {'b0};
        bins ones = {'b1};
     }
endgroup
// Constructor
  function new (string name="fifo_coverage", uvm_component parent);
     super.new(name, parent);
`uvm_info("COV_CLASS", "Inside Constructor!", UVM_HIGH)
     cov_group = new;
  endfunction : new
 //--------------------------------------------------------
 //Build Phase
 //--------------------------------------------------------
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("COV_CLASS", "Build Phase!", UVM_HIGH)
   coverage_port = new("coverage_port", this);
 endfunction: build_phase
 //--------------------------------------------------------
 //Connect Phase
 //--------------------------------------------------------
 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   `uvm_info("COV_CLASS", "Connect Phase!", UVM_HIGH)
 endfunction: connect_phase
 //--------------------------------------------------------
 //Write Method
 //--------------------------------------------------------
  function void write(fifo_sequence_item item);
//$cast(fifoTBintf,t.clone);
   transactions.push_back(item);
 endfunction: write
 //--------------------------------------------------------
 //Run Phase
 //--------------------------------------------------------
 task run_phase (uvm_phase phase);
   super.run_phase(phase);
   `uvm_info("COV_CLASS", "Run Phase!", UVM_HIGH)
   forever begin
     wait((transactions.size() != 0));
     fifoTBintf = transactions.pop_front();
     cov_group.sample();
   end
 endtask: run_phase
endclass: fifo_coverage