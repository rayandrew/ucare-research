#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_utils.sh"

cd "$DIR/source"

# check installation
check_program mvn || {
  echo >&2 "Maven program not found.  Aborting."
  exit 1
}

# Compiling maven
echo "Compiling Hadoop"
mvn package -Pdist -DskipTests -Dtar
echo "Hadoop has been compiled!"
