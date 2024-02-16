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


vsim work.tb_fifo
add wave -r *

run -all
