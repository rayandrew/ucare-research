# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash

task_count=$1

for ((i = 10; i <= $task_count; i += 10)); do
  for ((j = 0; j <= $i; j++)); do
    python3 cluster.py $task_count $j &
  done
done

echo "SLEEPING for 10s"

sleep 10

echo "READ MEM USAGE"

ps_mem -p $(pgrep -d, -f python)
