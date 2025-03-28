#!/bin/bash

# COMMAND USAGE: build.sh <testbench_name> [options]
# everything is optional except for the testbench name
# you can also use the -c flag to remove the generated build files

# Function to display help message
function display_help() {
  echo "Usage: $0 <testbench_name> [options]"
  echo "Arguments:"
  echo "   -a, --analyze              Only analyzes the source files and exit"
  echo "   -c, --clear, --clean       Clean the build directory and exit (this does not require a testbench_name)"
  echo "   --sources <dir>            Specify the source directory (default: $SRC_DIR)"
  echo "   --sim <dir>                Specify the simulation directory (default: $SIM_DIR)"
  echo "   -t, --time <time>          Specify the simulation time (default: $SIMULATION_TIME)"
  echo "   -h, --help                 Display this help message and exit"
  echo "To be able to run this script correctly you will need gtkwave and ghdl installed!"
}

function clean_build() {
  echo "Cleaning build directory..."
  rm -rf $BUILD_DIR
  echo "Done."
  exit 0
}

# DEFAULT VALUES
SRC_DIR="hw/src/rtl"
SIM_DIR="hw/src/tb"
BUILD_DIR="out"
SIMULATION_TIME=1ms
ANALIZE_ONLY=false

# Parse command line arguments: shift is used to advance the arguments
TESTBENCH_NAME=""
while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--analyze)
      ANALIZE_ONLY=true
      shift 1
      ;;
    -c|--clear|--clean)
      clean_build
      ;;
    --sources)
      if [ -n "$2" ]; then
        SRC_DIR=$2
        shift 2
      else
        echo "Error: --sources flag requires a directory argument."
        exit 1
      fi
      ;;
    --sim)
      if [ -n "$2" ]; then
        SIM_DIR=$2
        shift 2
      else
        echo "Error: --sim flag requires a directory argument."
        exit 1
      fi
      ;;
    -t|--time)
      if [ -n "$2" ]; then
        SIMULATION_TIME=$2
        shift 2
      else
        echo "Error: -t flag requires a time argument."
        exit 1
      fi
      ;;
    -h|--help)
      display_help
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"
      display_help
      exit 1
      ;;
    *)
      if [ -z "$TESTBENCH_NAME" ]; then
        TESTBENCH_NAME=$1
        shift
      else
        echo "Error: Multiple testbench names provided."
        exit 1
      fi
      ;;
  esac
done

# Check if testbench name is provided
if [ -z "$TESTBENCH_NAME" ]; then
  display_help
  exit 1
fi

# Echo all the variables
echo "Testbench Name: $TESTBENCH_NAME"
echo "Source Directory: $SRC_DIR"
echo "Simulation Directory: $SIM_DIR"
echo "Build Directory: $BUILD_DIR"
echo "Simulation Time: $SIMULATION_TIME"

# Create the build directory if it doesn't exist
mkdir -p $BUILD_DIR
mkdir -p $BUILD_DIR/bin

# Change to the build directory
# cd $BUILD_DIR/bin || exit 1

# Analyze VHDL source files
echo "Analyzing VHDL source files..."
ghdl -a --workdir="$BUILD_DIR/bin" --work=xil_defaultlib ./$SRC_DIR/*.vhd 
if [ $? -ne 0 ]; then
  echo "Error during source analysis."
  exit 1
fi

# Analyze VHDL testbench files
echo "Analyzing VHDL testbench files..."
ghdl -a -P$BUILD_DIR/bin --workdir="$BUILD_DIR/bin" ./$SIM_DIR/$TESTBENCH_NAME.vhd
if [ $? -ne 0 ]; then
  echo "Error during testbench analysis."
  exit 1
fi

# Exit + Clear if only analyze 
if [ "$ANALIZE_ONLY" = true ]; then
  echo "Analysis completed successfully."
  clean_build
fi

# Elaborate the project
echo "Elaborating the project..."
ghdl -e -P$BUILD_DIR/bin --workdir="$BUILD_DIR/bin" -o "$BUILD_DIR/bin/$TESTBENCH_NAME" $TESTBENCH_NAME
if [ $? -ne 0 ]; then
  echo "Error during elaboration."
  exit 1
fi

cd $BUILD_DIR/bin || exit 1

# Run the simulation
echo "Running the simulation..."
ghdl -r $TESTBENCH_NAME --wave="../wave.ghw" --stop-time=$SIMULATION_TIME
if [ $? -ne 0 ]; then
  echo "Error during simulation."
  exit 1
fi

cd ../..

# Open the simulation in GTKWave
echo "Opening simulation in GTKWave..."
gtkwave ./$BUILD_DIR/wave.ghw ./config.gtkw
if [ $? -ne 0 ]; then
  echo "Error opening GTKWave."
  exit 1
fi

echo "Simulation completed successfully."