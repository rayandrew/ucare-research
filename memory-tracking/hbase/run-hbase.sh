# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash
# This is used for starting multiple datanodes on the same machine.
# run it from hadoop-dir/ just like 'bin/hadoop'

#Usage: run-additionalDN.sh [start|stop] dnnumber
#e.g. run-datanode.sh start 2

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

export HADOOP_HOME=/mnt/extra/ucare-research/memory-tracking/memory-trackinghdfs/source/hadoop-dist/target/hadoop-2.7.1
export HBASE_HOME=/mnt/extra/ucare-research/memory-tracking/memory-trackinghbase/source/hbase-home/hbase-1.0.4-SNAPSHOT

echo "Kill all Java Process"
killall java

echo "Moving hadoop configuration file"
mv "$HADOOP_HOME/etc/hadoop/core-site.xml" "$HADOOP_HOME/etc/hadoop/core-site.bak.xml"
cp "$DIR/../hdfs/conf/core-site.xml" "$HADOOP_HOME/etc/hadoop"

mv "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" "$HADOOP_HOME/etc/hadoop/hdfs-site.bak.xml"
cp "$DIR/../hdfs/conf/hdfs-site.xml" "$HADOOP_HOME/etc/hadoop"

echo "Moving hbase configuration file"
mv "$HBASE_HOME/conf/hbase-site.xml" "$HBASE_HOME/conf/hbase-site.bak.xml"
cp "$DIR/conf/hbase-site.xml" "$HBASE_HOME/conf"

echo "Formatting HDFS"
rm -rf /tmp/hadoop-hsgucare/dfs/data/current/
yes Y | $HADOOP_HOME/bin/hdfs namenode -format
yes Y | $HADOOP_HOME/bin/hdfs datanode -format

echo "Starting HDFS"
$HADOOP_HOME/sbin/start-dfs.sh

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
