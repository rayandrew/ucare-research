#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cmd=$1

echo "Building program"

gradle build

echo "Finish building the program"
