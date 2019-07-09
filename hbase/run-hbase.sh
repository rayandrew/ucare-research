# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash
# This is used for starting multiple datanodes on the same machine.
# run it from hadoop-dir/ just like 'bin/hadoop'

#Usage: run-additionalDN.sh [start|stop] dnnumber
#e.g. run-datanode.sh start 2

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

export HADOOP_HOME=/mnt/extra/ucare-research/hdfs/source/hadoop-dist/target/hadoop-2.7.1
export HBASE_HOME=/mnt/extra/ucare-research/hbase/source/hbase-home/hbase-1.0.4-SNAPSHOT/

echo "Moving configuration file"
mv "$HBASE_HOME/conf/hbase-site.xml" "$HBASE_HOME/conf/hbase-site.bak.xml"
cp "$DIR/conf/hbase-site.xml" "$HBASE_HOME/conf"

echo "Starting HDFS"
$HADOOP_HOME/sbin/start-dfs.sh

sleep 2

echo "Starting master"
$HBASE_HOME/bin/start-hbase.sh

cmd=$1
sleep 2

params=""

for ((i = 1; i <= $cmd; i++)); do
  if [ -z "$params" ]; then
    params="$i"
  else
    params="$params $i"
  fi
done

echo "Run RegionServers"
$HBASE_HOME/bin/local-regionservers.sh start "$params"
