#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

echo "Installing Dependencies"

sudo apt-get install build-essential libncurses-dev bison flex libssl-dev libelf-dev coreutils software-properties-common -y

sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y

sudo apt-get install gcc g++ gcc-7 g++-7

sudo update-alternatives --remove-all gcc

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7

echo "Finish installing dependencies"



