## This sources has been taken mostly from this site
## https://www.cyberciti.biz/tips/compiling-linux-kernel-26.html
## All credits belong to nixCraft

#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

cd ./source

echo "Preparing Configurations"

make menuconfig

cp -v /boot/config-$(uname -r) .config

echo "Done preparing configurations"
