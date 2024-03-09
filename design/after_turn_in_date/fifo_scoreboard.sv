/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_imp #(fifo_sequence_item, fifo_scoreboard) scoreboard_port;
  
  typedef fifo_scoreboard fifo_scoreboard_t;
  typedef fifo_coverage	fifo_coverage_t;
    typedef fifo_sequence_item fifo_item_t;
  uvm_analysis_imp_w#(fifo_item_t, fifo_scoreboard_t) 	wimp;
  uvm_analysis_imp_r#(fifo_item_t, fifo_scoreboard_t) 	rimp;
  
localparam FIFO_LEN = 	1 << POINTERSIZE;
  //golden fifo
  bit [DATASIZE - 1:0]	fifo[$];

  fifo_item_t wq[$];
  fifo_item_t rq[$];

  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)

  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    scoreboard_port = new("scoreboard_port", this);
        wimp = new("wimp", this);
    rimp = new("rimp", this);
  endfunction: build_phase
  
  

   virtual function void check_phase(uvm_phase phase);
    int i = 0;
    int j = 0;
    
    `uvm_info(get_name(), "START CHECK PHASE", UVM_MEDIUM);
    `uvm_info(get_name(), $sformatf("wq.size() = %d", wq.size()), UVM_MEDIUM);
    `uvm_info(get_name(), $sformatf("rq.size() = %d", rq.size()), UVM_MEDIUM);
    
    while (i < wq.size() && j < rq.size()) begin
      if (wq[i].t < rq[j].t) begin
        process_write(wq[i]);
        i++;
      end
      
      else begin
        process_read(rq[j]);
        j++;
      end
    end
    
    while (i < wq.size()) begin
      process_write(wq[i]);
      i++;
    end
    
    while (j < rq.size()) begin
      process_read(rq[j]);
      j++;
    end
    
  endfunction
  
  
  //write methods
  virtual function void write_w(input fifo_item_t item);
    item.t = $time;
    wq.push_back(item);
    
    //`uvm_info(get_name(), $sformatf("received write trans: %s\n", trans.wconvert2string()), UVM_MEDIUM);
  endfunction
  
  virtual function void write_r(input fifo_item_t item);
    item.t = $time;
	rq.push_back(item);
    
    //`uvm_info(get_name(), $sformatf("received read trans: %s\n", trans.rconvert2string()), UVM_MEDIUM);
  endfunction
  
  
  //helper functions
  function void process_read(fifo_item_t item);
    bit [DATASIZE - 1:0] buff;
    
    //cov.cg_fifo_len.sample(fifo.size());
    
    if (!item.rrst_n) begin
      fifo.delete();
      if (!item.rempty) begin
        `uvm_error(get_name(), "rrst_n but rempty is not asserted");
      end
    end
    
    else begin
      if (fifo.size() == 0 && !item.rempty) begin
        `uvm_error(get_name(), "fifo is empty but rempty is not asserted");
      end

      else if (item.rinc && !item.rempty) begin
        buff = fifo.pop_front();
        if (buff != item.rdata) begin
          `uvm_error(get_name(), $sformatf("rdata mismatch between expected [%x] and actual [%x]", buff, item.rdata));
        end
      end
    end
    
   // cov.cg_fifo_len.sample(fifo.size());
    //cov.cg_trans.sample(trans);
    
  endfunction
  
  function void process_write(fifo_item_t item);
  //  cov.cg_fifo_len.sample(fifo.size());
    
    if (!item.wrst_n) begin
      fifo.delete();
      if (item.wfull) begin
        `uvm_error(get_name(), "wrst_n but wfull is asserted");
      end
    end
    
    else begin
      if (fifo.size() == FIFO_LEN && !item.wfull) begin
        `uvm_error(get_name(), "fifo is full but wfull is not asserted");
      end
      
      else if (item.winc && !item.wfull) begin
        fifo.push_back(item.wdata);
      end
    end
    
  endfunction
  
endclass : fifo_scoreboard