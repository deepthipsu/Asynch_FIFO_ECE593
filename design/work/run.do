vlib work
vdel -all
vlib work


vlog definitions.sv
vlog sync_w2r.sv
vlog sync_r2w.sv 


vlog fifomem.sv
vlog fifo_ack.sv
vlog Async_FIFO.sv
vlog Async_FIFO_tb.sv

vsim work.tb
add wave -r *

run -all