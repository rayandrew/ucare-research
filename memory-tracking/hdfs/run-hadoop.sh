# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash
# This is used for starting multiple datanodes on the same machine.
# run it from hadoop-dir/ just like 'bin/hadoop'

#Usage: run-additionalDN.sh [start|stop] dnnumber
#e.g. run-datanode.sh start 2

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

export PROJ_DIR="/mnt/extra/ucare-research/memory-tracking/memory-trackinghdfs"

export HADOOP_HOME="$PROJ_DIR/source/hadoop-dist/target/hadoop-2.7.1"
export HADOOP_CONF_DIR="$PROJ_DIR/source/hadoop-dist/target/hadoop-2.7.1/etc/hadoop"
# export HADOOP_LOG_DIR="/mnt/extra/logs/master"

export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64/"
export DN_DIR_PREFIX="$PROJ_DIR/source/hadoop-dist/target/hadoop-2.7.1/logs/slaves-"

if [ -z $DN_DIR_PREFIX ]; then
  echo $0: DN_DIR_PREFIX is not set. set it to something like "/hadoopTmp/dn"
  exit 1
fi

rm -rf $HADOOP_HOME/logs
mkdir -p $HADOOP_HOME/logs
# mkdir -p $DN_DIR_PREFIX

echo "Moving conf file"
mv "$HADOOP_HOME/etc/hadoop/core-site.xml" "$HADOOP_HOME/etc/hadoop/core-site.bak.xml"
cp "$DIR/conf/core-site.xml" "$HADOOP_HOME/etc/hadoop"

mv "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" "$HADOOP_HOME/etc/hadoop/hdfs-site.bak.xml"
cp "$DIR/conf/hdfs-site.xml" "$HADOOP_HOME/etc/hadoop"

run_master() {
  export HADOOP_LOG_DIR="/mnt/extra/logs/master"
  $HADOOP_HOME/sbin/start-dfs.sh
}

run_datanode() {
  DN=$2
  export HADOOP_LOG_DIR=$DN_DIR_PREFIX$DN/logs
  export HADOOP_PID_DIR=$HADOOP_LOG_DIR
  DN_CONF_OPTS="\
  -Dhadoop.tmp.dir=$DN_DIR_PREFIX$DN \
  -Ddfs.datanode.address=0.0.0.0:200$DN \
  -Ddfs.datanode.http.address=0.0.0.0:300$DN \
  -Ddfs.datanode.ipc.address=0.0.0.0:400$DN"
  $HADOOP_HOME/sbin/hadoop-daemon.sh --script $HADOOP_HOME/bin/hdfs $1 datanode $DN_CONF_OPTS
}

run_master

cmd=$1

sleep 2

for ((i = 1; i <= $2; i++)); do
  run_datanode $cmd $i
done
