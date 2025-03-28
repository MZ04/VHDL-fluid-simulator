# Load synthesis results
source ./scripts/tcl/synth.tcl

# Run implementation
opt_design
place_design
route_design
write_checkpoint -force ./hw/reports/post_impl.dcp

# Generate bitstream
write_bitstream -force ./hw/bitstreams/fsm.bit
report_timing_summary -file ./hw/reports/implementation_timing.txt

puts "Implementation and bitstream generation complete."
