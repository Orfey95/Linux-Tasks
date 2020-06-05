#!/bin/bash
  
set -e

# Exit codes
NODE_EXIT=1
ONE_CORE_EXIT=1

# Variables
MAX_SCHED_WORKERS=""
SCHED_NUMA_NODES=""
SCHED_NUMA_1="null"
SCHED_NUMA_2="null"

# If nodes equal -> exit
cpu_node=$(lscpu -b --parse="NODE" | grep -v "#" | tr ' ' '\n' | uniq -u)
if [ -z "$cpu_node" ]; then
  exit $NODE_EXIT
fi
# If there is only one CPU -> exit
cpu_counter=$(lscpu -b --parse="CPU" | grep -v "#" | wc -w)
if [ "$cpu_counter" = "1" ]; then
  exit $ONE_CORE_EXIT
fi
#################
# If CPU model is Intel
if lscpu | grep -q "Intel"; then
  # Get string of cores
  csv_core=$(lscpu -b --parse="CORE" | grep -v "#")
  csv_core=$(echo $csv_core | tr ' ' ',')

  # Get array of cores
  IFS=',' read -ra csv_core_array <<< "$csv_core"

  # get repeat cpu by core
  repeat_cpu=""
  for ((csv_core_array_x=0;csv_core_array_x<$(echo "${#csv_core_array[@]}");csv_core_array_x++)); do
    for ((csv_core_array_y=$(echo ${csv_core_array_x}+1 | bc);csv_core_array_y<$(echo "${#csv_core_array[@]}");csv_core_array_y++)); do
      if [ ${csv_core_array[$csv_core_array_x]} = ${csv_core_array[$csv_core_array_y]} ]; then
          repeat_cpu="${repeat_cpu} ${csv_core_array_y}"
      fi
    done
  done

  # Create array from repeat_cpu
  IFS=' ' read -ra repeat_cpu_array <<< "$repeat_cpu"

  # Turn off Hyper-threading
  for element in "${repeat_cpu_array[@]}"; do
    echo "0" | tee /sys/devices/system/cpu/cpu"$element"/online > /dev/null 2>&1
  done
fi
################
# Print number of CPU (after turn off Hyper-threading)
MAX_SCHED_WORKERS=$(lscpu -b --parse="CPU" | grep -v "#" | wc -w)

# Print number of NUME
SCHED_NUMA_NODES=$(lscpu -b --parse="NODE" | grep -v "#" | uniq | wc -w)

# Print NUME number for each CPU
cpu_node=$(lscpu -b --parse="NODE" | grep -v "#" | tr '\r\n' ',')
IFS=',' read -ra cpu_node_array <<< "$cpu_node"
cpu_number=$(lscpu -b --parse="CPU" | grep -v "#" | tr '\r\n' ',')
IFS=',' read -ra cpu_number_array <<< "$cpu_number"

for ((cpu_node_array_element=0;cpu_node_array_element<$(echo "${#cpu_node_array[@]}");cpu_node_array_element++)); do
  if [ ${cpu_node_array[$cpu_node_array_element]} = "0" ]; then
    if [ $SCHED_NUMA_1 = "null" ]; then
      SCHED_NUMA_1=""
    fi
    SCHED_NUMA_1="${SCHED_NUMA_1},${cpu_number_array[$cpu_node_array_element]}"
  fi
  if [ ${cpu_node_array[$cpu_node_array_element]} = "1" ]; then
    SCHED_NUMA_2="${SCHED_NUMA_2},${cpu_number_array[$cpu_node_array_element]}"
  fi
done
if [ $SCHED_NUMA_1 != "null" ]; then
      SCHED_NUMA_1="${SCHED_NUMA_1:1}"
fi
if [ $SCHED_NUMA_2 != "null" ]; then
      SCHED_NUMA_2="${SCHED_NUMA_2:1}"
fi
#######
RESULT="$MAX_SCHED_WORKERS|$SCHED_NUMA_NODES|$SCHED_NUMA_1|$SCHED_NUMA_2"
echo "$RESULT"