# COMMAND USAGE: build.sh <testbench_name> <simulation_time> <src_dir> <sim_dir>
# everything is optional except for the testbench name

# you can also use the -c flag to remove the generated build files

# Directory paths
SRC_DIR="Fluid_dynamic.srcs/sources_1/new"
SIM_DIR="Fluid_dynamic.srcs/sim_1/new"
BUILD_DIR="./build"

# Check for the -c flag and perform an action if present
CLEAN_BUILD=false
while getopts ":c" opt; do
  case $opt in
    c)
      CLEAN_BUILD=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Check for the --sources flag and update the SRC_DIR if present
# while [[ $# -gt 0 ]]; do
#   case $1 in
#     --sources)
#       if [ -n "$2" ]; then
#         SRC_DIR=$2
#         shift 2
#       else
#         echo "Error: --sources flag requires a directory argument."
#         exit 1
#       fi
#       ;;
#     *)
#       break
#       ;;
#   esac
# done

if $CLEAN_BUILD; then
  echo "Cleaning build directory..."
  rm -rf $BUILD_DIR
  echo "Done."
  exit 0
fi

# Check if testbench name is provided as an argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <testbench_name>"
  exit 1
fi

TESTBENCH_NAME=$1
SIMULATION_TIME=1ms

if [ $# -ge 2 ]; then
  SIMULATION_TIME=$2
fi

# Create the build directory if it doesn't exist
mkdir -p $BUILD_DIR

# Change to the build directory
cd $BUILD_DIR || exit 1

# Analyze VHDL source files
echo "Analyzing VHDL source files..."
ghdl -a --work=xil_defaultlib ../$SRC_DIR/*.vhd
if [ $? -ne 0 ]; then
  echo "Error during source analysis."
  exit 1
fi

# Analyze VHDL testbench files
echo "Analyzing VHDL testbench files..."
ghdl -a ../$SIM_DIR/$TESTBENCH_NAME.vhd
if [ $? -ne 0 ]; then
  echo "Error during testbench analysis."
  exit 1
fi

# Elaborate the project
echo "Elaborating the project..."
ghdl -e $TESTBENCH_NAME
if [ $? -ne 0 ]; then
  echo "Error during elaboration."
  exit 1
fi

# Run the simulation
echo "Running the simulation..."
ghdl -r $TESTBENCH_NAME --wave=wave.ghw --stop-time=$SIMULATION_TIME
if [ $? -ne 0 ]; then
  echo "Error during simulation."
  exit 1
fi

# Open the simulation in GTKWave
echo "Opening simulation in GTKWave..."
gtkwave wave.ghw
if [ $? -ne 0 ]; then
  echo "Error opening GTKWave."
  exit 1
fi

echo "Simulation completed successfully."