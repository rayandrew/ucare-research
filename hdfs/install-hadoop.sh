#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_utils.sh"

# we set dir 2 times to include files
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cd "$DIR/source"

# check installation
check_program mvn || {
  echo >&2 "Maven program not found.  Aborting."
  exit 1
}

# Compiling maven
echo "Compiling Hadoop"
mvn -Dhttps.protocols=TLSv1.2 package -Pdist -DskipTests -Dtar
echo "Hadoop has been compiled!"
