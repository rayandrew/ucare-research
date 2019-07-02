#!/bin/bash

# creating dirs
mkdir temp-jdk

# download zulu
wget https://cdn.azul.com/zulu/bin/zulu7.29.0.5-ca-jdk7.0.222-linux_amd64.deb -O temp-jdk/jdk7.deb

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
sudo dpkg -i temp-jdk/jdk7.deb
