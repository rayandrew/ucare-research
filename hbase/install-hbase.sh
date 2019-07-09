#!/bin/bash

CURRENT_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$CURRENT_DIR" ]]; then CURRENT_DIR="$PWD"; fi

source "$CURRENT_DIR/_utils.sh"

cd "$CURRENT_DIR/source"

# check installation
check_program mvn || {
  echo >&2 "Maven program not found.  Aborting."
  exit 1
}

# Compiling HBase
echo "Compiling HBase"
# mvn clean -Dhttps.protocols=TLSv1.2 package -DskipTests
mvn clean install -Dhttps.protocols=TLSv1.2 -DskipTests assembly:single
echo "HBase has been compiled!"
