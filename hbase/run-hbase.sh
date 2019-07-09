# Taken from https://bigdata.wordpress.com/2010/05/27/hadoop-cookbook-4-how-to-run-multiple-data-nodes-on-one-machine/

#!/bin/bash
# This is used for starting multiple datanodes on the same machine.
# run it from hadoop-dir/ just like 'bin/hadoop'

#Usage: run-additionalDN.sh [start|stop] dnnumber
#e.g. run-datanode.sh start 2

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cmd=$1

sleep 2

export HBASE_HOME=/mnt/extra/ucare-research/hbase/source/hbase-home/hbase-1.0.4-SNAPSHOT/

echo "Moving configuration file"
mv "$HBASE_HOME/conf/hbase-site.xml" "$HBASE_HOME/conf/hbase-site.bak.xml"
cp "$DIR/conf/hbase-site.xml" "$HBASE_HOME/conf"

# for ((i = 1; i <= $2; i++)); do
#   run_datanode $cmd $i
# done
