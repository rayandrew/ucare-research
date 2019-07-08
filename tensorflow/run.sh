# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash

task_count=$1

for ((i = 1; i <= $task_count; i++)); do
  python3 cluster.py $task_count $i
done
