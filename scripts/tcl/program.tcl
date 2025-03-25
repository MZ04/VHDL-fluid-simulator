# Open hardware connection
open_hw
connect_hw_server
open_hw_target

# Set up the device
set fpga_device [lindex [get_hw_devices] 0]
current_hw_device $fpga_device
refresh_hw_device -update_hw_probes false $fpga_device

# Load bitstream
set bitfile "./hw/bitstreams/top.bit"
if {![file exists $bitfile]} {
    puts "Error: Bitstream file not found!"
    exit 1
}

# Program FPGA
puts "Programming FPGA with $bitfile..."
program_hw_devices $bitfile
refresh_hw_device $fpga_device

puts "FPGA successfully programmed."
