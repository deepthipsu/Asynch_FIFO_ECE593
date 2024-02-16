vlib work
vdel -all
vlib work


vlog definitions.sv
vlog transaction.sv
vlog environment.sv 
vlog fifoInterface.sv
vlog asynchFIFO_tb.sv
vlog AsynchFIFO.sv
vlog driver.sv
vlog test.sv
vlog monitor.sv
vlog scoreboard.sv
vopt +cover=bcesxf tb_fifo -o test_sm_opt

vsim -coverage test_sm_opt
add wave -r *

run -all