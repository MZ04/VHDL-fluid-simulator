# Remove existing constraints (prevents duplicates)
reset_run synth_1
reset_run impl_1

# Define constraint directory
set constr_dir [file normalize "./hw/constraints"]

# Add all .xdc constraint files dynamically
foreach xdc_file [glob -nocomplain -directory $constr_dir *.xdc] {
    if {[file exists $xdc_file]} {
        add_files -fileset constrs_1 $xdc_file
        puts "Added constraint file: $xdc_file"
    } else {
        puts "Warning: Constraint file not found -> $xdc_file"
    }
}

# Ensure at least one constraint file is added
if {[llength [get_files -of_objects [get_filesets constrs_1]]] == 0} {
    puts "Error: No constraint files found. Verify your constraints directory."
    exit 1
}

puts "Constraints loaded."
