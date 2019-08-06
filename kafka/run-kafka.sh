# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash
# This is used for starting multiple datanodes on the same machine.
# run it from hadoop-dir/ just like 'bin/hadoop'

#Usage: run-additionalDN.sh [start|stop] dnnumber
#e.g. run-datanode.sh start 2

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

export KAFKA_HOME=/mnt/extra/ucare-research/kafka/source

echo "Kill all Java Process"
kill -9 $(ps aux | grep "java" | grep -v 'grep' | awk '{print $2}')

echo "Delete logs"
rm -rf $KAFKA_HOME/logs/*
rm -rf /tmp/zookeeper
rm -rf /tmp/kafka-logs

mkdir /tmp/kafka-logs

echo "Starting Zookeeper"
# $HADOOP_HOME/sbin/start-dfs.sh
$KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties
sleep 3

cmd=$1

echo "Generating multiple configs"

python3 gen_config.py --config_template $KAFKA_HOME/config/server.properties --server_count $cmd

echo "Starting multiple servers"

for ((i = 0; i < $cmd; i++)); do
  LOG_DIR=/tmp/kafka-logs/$i $KAFKA_HOME/bin/kafka-server-start.sh -daemon configs/server-$i.properties
done
