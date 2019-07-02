#!/bin/bash

PROTOBUF_VERSION="2.5.0"

# creating dirs
mkdir -p temp-protobuf

# download zulu jdk
wget https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-$PROTOBUF_VERSION.tar.gz -O temp-protobuf/protobuf-$PROTOBUF_VERSION.tar.gz

# Untar
tar xvf temp-protobuf/protobuf-$PROTOBUF_VERSION.tar.gz

# change dir
cd temp-protobuf/protobuf-$PROTOBUF_VERSION

# autogen
./autogen.sh

# configure
./configure --prefix=/usr

# make and install
make && make install

# check installation
if which gls &>/dev/null; then
  exit 1
fi
