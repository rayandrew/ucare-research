#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

n=$1

echo "Kill all Java Process"
kill -9 $(ps aux | grep "java" | grep -v 'grep' | awk '{print $2}')

echo "Remove logs folder"
rm -rf ./logs/*

echo "Starting multiple programs"

for ((i = 0; i < $n; i++)); do
  logDir=./logs/$i nohup java -Xmx256m -XX:+UseG1GC -XX:+UseStringDeduplication -jar build/libs/string-dedup-fat.jar >/dev/null 2>&1 &
done

echo "Done bootstrapping multiple programs"
