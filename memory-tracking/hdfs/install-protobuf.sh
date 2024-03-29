#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_utils.sh"

TEMP_FOLDER="temp-protobuf"
PROTOBUF_VERSION="2.5.0"

# install build essentials
sudo apt-get update && sudo apt-get install build-essential -y

# creating dirs
mkdir -p $TEMP_FOLDER

# download zulu jdk
wget https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-$PROTOBUF_VERSION.tar.gz \
  -O $TEMP_FOLDER/protobuf-$PROTOBUF_VERSION.tar.gz

# Untar
tar xvf $TEMP_FOLDER/protobuf-$PROTOBUF_VERSION.tar.gz -C $TEMP_FOLDER

# change dir
cd $TEMP_FOLDER/protobuf-$PROTOBUF_VERSION

# autogen
./autogen.sh

# configure
./configure --prefix=/usr

# make and install
sudo make && sudo make check && sudo make install

# check installation
check_program protoc || {
  echo >&2 "Protobuf program not found.  Aborting."
  exit 1
}

echo "Protobuf installation succeed!"

# remove dir
rm -rf $TEMP_FOLDER
