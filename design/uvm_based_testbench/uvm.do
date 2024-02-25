
vlib work
vdel -all
vlib work


vlog definitions.sv
vlog interface_uvm.sv
vlog testbench_uvm.sv
vlog asynchFIFO.sv
vlog fifo_sequence_item.sv
vopt +cover=bcesxf tb_fifo_uvm -o test_sm_opt

vsim -coverage test_sm_opt
add wave -r *

run -all
