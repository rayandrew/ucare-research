#!/bin/bash

CURRENT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$CURRENT_DIR" ]]; then CURRENT_DIR="$PWD"; fi

source "$CURRENT_DIR/_utils.sh"

cd "$CURRENT_DIR/source"

export KAFKA_VERSION="1.0.4"
# export KAFKA_HOME="$CURRENT_DIR/hbase-home"
# export PATH=$HBASE_HOME/bin:$PATH

# mkdir -p $HBASE_HOME

# check installation
check_program gradle || {
  echo >&2 "Gradle program not found.  Aborting."
  exit 1
}

# Compiling HBase
echo "Compiling Kafka"
# mvn clean -Dhttps.protocols=TLSv1.2 package -DskipTests
gradle
gradle jar
echo "Kafka has been compiled!"
