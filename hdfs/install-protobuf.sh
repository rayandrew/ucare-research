#!/bin/bash

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
make && make install

# check installation
command -v protoc >/dev/null 2>&1 || {
  echo >&2 "Protobuf installation failed.  Aborting."
  exit 1
}

# remove dir
rm -rf $TEMP_FOLDER
