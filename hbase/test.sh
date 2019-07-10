#!/bin/bash

cmd=$1

params=""

for ((i = 2; i <= $cmd; i++)); do
  if [ -z "$params" ]; then
    params="$i"
  else
    params="$params $i"
  fi
done

echo "$params"
