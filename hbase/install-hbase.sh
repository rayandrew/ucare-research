#!/bin/bash

CURRENT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$CURRENT_DIR" ]]; then CURRENT_DIR="$PWD"; fi

source "$CURRENT_DIR/_utils.sh"

cd "$CURRENT_DIR/source"

export HBASE_VERSION="1.0.4"
export HBASE_HOME="$CURRENT_DIR/hbase-home"
export PATH=$HBASE_HOME/bin:$PATH

mkdir -p $HBASE_HOME

# check installation
check_program mvn || {
  echo >&2 "Maven program not found.  Aborting."
  exit 1
}

# Compiling HBase
echo "Compiling HBase"
# mvn clean -Dhttps.protocols=TLSv1.2 package -DskipTests
mvn clean install -Dhttps.protocols=TLSv1.2 -DskipTests assembly:single
tar xzvf hbase-assembly/target/hbase-$CURRENT_DIR-SNAPSHOT-bin.tar.gz -C $HBASE_HOME
echo "HBase has been compiled!"
