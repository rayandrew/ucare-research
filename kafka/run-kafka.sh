# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash
# This is used for starting multiple datanodes on the same machine.
# run it from hadoop-dir/ just like 'bin/hadoop'

#Usage: run-additionalDN.sh [start|stop] dnnumber
#e.g. run-datanode.sh start 2

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

export KAFKA_HOME=/mnt/extra/ucare-research/kafka

echo "Kill all Java Process"
killall java

echo "Starting Zookeeper"
# $HADOOP_HOME/sbin/start-dfs.sh
./bin/kafka-server-start.sh -daemon config/server.properties

sleep 2

echo "Starting master"
$HBASE_HOME/bin/start-hbase.sh

cmd=$1
sleep 2

params=""

# starting from the second as master already deploy the first
for ((i = 2; i <= $cmd; i++)); do
  if [ -z "$params" ]; then
    params="$i"
  else
    params="$params $i"
  fi
done

echo "Run RegionServers"
$HBASE_HOME/bin/local-regionservers.sh start "$params"
