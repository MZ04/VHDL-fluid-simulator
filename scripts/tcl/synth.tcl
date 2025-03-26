# Load project setup
source ./scripts/tcl/create_project.tcl

# Run synthesis
synth_design -top fsm -part xc7a100tcsg324-1
write_checkpoint -force ./hw/reports/post_synth.dcp
report_timing_summary -file ./hw/reports/synthesis_timing.txt

puts "Synthesis complete."
