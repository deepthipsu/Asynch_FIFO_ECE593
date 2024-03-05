class fifo_environment extends uvm_env;
 `uvm_component_utils(fifo_environment)
 fifo_write_agent wagnt;
 fifo_read_agent ragnt;
 fifo_scoreboard scb;
 fifo_coverage cov;
 //--------------------------------------------------------
 //Constructor
 //--------------------------------------------------------
 function new(string name = "fifo_environment", uvm_component parent);
   super.new(name, parent);
   `uvm_info("ENV_CLASS", "Inside Constructor!", UVM_HIGH)
 endfunction: new
 //--------------------------------------------------------
 //Build Phase
 //--------------------------------------------------------
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("ENV_CLASS", "Build Phase!", UVM_HIGH)
   wagnt = fifo_write_agent::type_id::create("wagnt", this);
   ragnt = fifo_read_agent::type_id::create("ragnt", this);
   scb = fifo_scoreboard::type_id::create("scb", this);
   cov = fifo_coverage::type_id::create("cov", this);
 endfunction: build_phase
 //--------------------------------------------------------
 //Connect Phase
 //--------------------------------------------------------
 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   `uvm_info("ENV_CLASS", "Connect Phase!", UVM_HIGH)
   wagnt.wmon.monitor_port.connect(scb.scoreboard_port);
   ragnt.rmon.monitor_port.connect(scb.scoreboard_port);
wagnt.wmon.monitor_port.connect(cov.coverage_port);
ragnt.rmon.monitor_port.connect(cov.coverage_port);
 //  ragnt.rmon.monitor_port.connect(cov.cov_port);
//ragnt.monitor_port.connect(cov.cov_port);
//cov.cov_port.connect(scb.scoreboard_port);
//scb.scoreboard_port.connect(cov.analysis_export);
 endfunction: connect_phase
endclass: fifo_environment