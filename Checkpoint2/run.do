vlib work
vdel -all
vlib work

vlog definitions.sv
vlog driver.sv +acc
vlog environment.sv +acc
vlog fifoInterface.sv +acc
vlog generator.sv +acc
vlog transaction.sv +acc
vlog test.sv +acc
vlog asynchFIFO.sv +acc
vlog asynchFIFO_tb.sv +acc

vsim work.tb_fifo
add wave -r *
run -all