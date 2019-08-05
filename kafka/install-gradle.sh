#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_utils.sh"

TEMP_FOLDER="temp-gradle"
GRADLE_VERSION="5.5.1"
DEST_FOLDER="/opt/gradle"
# BASHRC="$HOME/.bashrc"

sudo rm -rf $DEST_FOLDER && sudo rm -rf /opt/gradle-$GRADLE_VERSION

# make temp
mkdir $TEMP_FOLDER

# make destination folder
sudo mkdir -p $DEST_FOLDER

# download maven
wget https://gradle.org/next-steps/?version=$GRADLE_VERSION &
format=bin \
  -O $TEMP_FOLDER/gradle-$GRADLE_VERSION-bin.zip

# Untar
sudo unzip -d $DEST_FOLDER $TEMP_FOLDER/gradle-$GRADLE_VERSION-bin.zip

# remove tmp
rm -rf $TEMP_FOLDER
