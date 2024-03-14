vlib work
vdel -all
vlib work


vlog definitions.sv +UVM_VERBOSITY=UVM_HIGH
vlog interface_uvm.sv +UVM_VERBOSITY=UVM_HIGH
vlog asynchFIFO.sv +UVM_VERBOSITY=UVM_HIGH
vlog fifo_sequence_item.sv +UVM_VERBOSITY=UVM_HIGH
vlog testbench_uvm.sv +acc +UVM_VERBOSITY=UVM_HIGH



vopt +cover=bcesxf tb_fifo_uvm -o test_sm_opt  +UVM_VERBOSITY=UVM_HIGH
vsim -coverage test_sm_opt
add wave -position insertpoint sim:/tb_fifo_uvm/fifoTBintf/*
run -all 



