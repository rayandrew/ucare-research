#!/bin/bash

# install software properties common
sudo apt-get update && sudo apt-get install software-properties-common

# add openjdk 8
sudo add-apt-repository ppa:openjdk-r/ppa && sudo apt-get update && sudo apt-get install openjdk-8-jdk

# install python
sudo apt install python3-pip
sudo pip3 install -vU setuptools
pip3 install jproperties --upgrade --user
