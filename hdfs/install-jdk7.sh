#!/bin/bash

source "_utils.sh"

TEMP_FOLDER="temp-jdk"
JDK_VERSION="7.0.222"

# creating dirs
mkdir -p $TEMP_FOLDER

# download zulu
wget https://cdn.azul.com/zulu/bin/zulu7.29.0.5-ca-jdk$JDK_VERSION-linux_amd64.deb -O $TEMP_FOLDER/jdk$JDK_VERSION.deb

# install deps
sudo apt-get update && sudo apt-get --fix-broken install \
  java-common \
  libasound2 \
  libasound2-data \
  libxi6 \
  libxrender1 \
  libxtst6 \
  x11-common \
  libfontconfig1 \
  fontconfig-config \
  fonts-dejavu-core

# install jdk7
sudo dpkg -i $TEMP_FOLDER/jdk$JDK_VERSION.deb

# check installation
check_program java || {
  echo >&2 "Java installation failed.  Aborting."
  exit 1
}

# remove tmp
rm -rf $TEMP_FOLDER
