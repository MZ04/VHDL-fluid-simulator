# Set project variables
set proj_name "fluid-simulator"
set fpga_part "xc7a200tfbg676-2"
set src_dir [file normalize "./hw/src/rtl"]
set tb_dir  [file normalize "./hw/src/tb"]

# Start a new project (non-project mode)
create_project -in_memory -part $fpga_part

# Add all RTL sources dynamically
foreach vhd_file [glob -nocomplain -directory $src_dir *.vhd] {
    add_files $vhd_file
    puts "Added RTL source: $vhd_file"
}

# Add testbenches
foreach vhd_file [glob -nocomplain -directory $tb_dir *.vhd] {
    add_files -fileset sim_1 $vhd_file
    puts "Added Testbench: $vhd_file"
}

# Load constraints
source ./scripts/tcl/constraints.tcl

# Sets top module
set_property top fsm [current_fileset]

puts "Project setup complete."

start_gui