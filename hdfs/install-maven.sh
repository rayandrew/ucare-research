#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_utils.sh"

TEMP_FOLDER="temp-maven"
MAVEN_VERSION="3.6.1"
JAVA_DIR="zulu-7-amd64"
DEST_FOLDER="/opt"
M2_HOME="/opt/maven"
BASHRC="~/.bashrc"

sudo rm -rf /opt/maven && sudo rm -rf /opt/apache-maven-$MAVEN_VERSION

# make temp
mkdir $TEMP_FOLDER

# download maven
wget https://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  -O $TEMP_FOLDER/maven-$MAVEN_VERSION.tar.gz

# Untar
sudo tar xvf $TEMP_FOLDER/maven-$MAVEN_VERSION.tar.gz -C $DEST_FOLDER

# Make link
sudo ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven

# create profile
check_var_exist $JAVA_HOME $(echo "export JAVA_HOME=/usr/lib/jvm/$JAVA_DIR" >>$BASHRC)
check_var_exist $M2_HOME \
  $(
    echo "export M2_HOME=${M2_HOME}" >>$BASHRC
    echo "export JAVA_HOME=/usr/lib/jvm/$JAVA_DIR" >>$BASHRC
    echo "export PATH=${M2_HOME}/bin:${PATH}" >>$BASHRC
  )

# chmod
# sudo chmod +x $MAVEN_PROFILE

# source file
source $BASHRC

# # check installation
check_program mvn || {
  echo >&2 "Maven program not found.  Aborting."
  exit 1
}

echo "Maven installation succeed!"

# remove tmp
rm -rf $TEMP_FOLDER
