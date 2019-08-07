#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cmd=$1

echo "Starting multiple programs"

for ((i = 0; i < $cmd; i++)); do
  logDir=./logs/$i nohup java -jar build/libs/dummy-process-fat.jar &
done

echo "Stopping multiple programs"
