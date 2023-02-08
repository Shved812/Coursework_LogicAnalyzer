onerror {exit -code 1}
vlib work
vlog -work work TEST_PROJECT_1.vo
vlog -work work modulator.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.modulator_vlg_vec_tst -voptargs="+acc"
vcd file -direction TEST_PROJECT_1.msim.vcd
vcd add -internal modulator_vlg_vec_tst/*
vcd add -internal modulator_vlg_vec_tst/i1/*
run -all
quit -f
