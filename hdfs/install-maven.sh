#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_utils.sh"

TEMP_FOLDER="temp-maven"
MAVEN_VERSION="3.6.1"
JAVA_DIR="zulu-7-amd64"
DEST_FOLDER="/opt"
MAVEN_PROFILE="/etc/profile.d/maven.sh"

# download maven
wget https://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  -O $TEMP_FOLDER/maven-$MAVEN_VERSION.tar.gz

# Untar
tar xvf $TEMP_FOLDER/maven-$MAVEN_VERSION.tar.gz -C $DEST_FOLDER

# Make link
sudo ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven

# create profile
sudo echo "export JAVA_HOME=/usr/lib/jvm/$JAVA_DIR" >>$MAVEN_PROFILE
sudo echo "export M2_HOME=/opt/maven" >>$MAVEN_PROFILE
sudo echo "export MAVEN_HOME=/opt/maven" >>$MAVEN_PROFILE
sudo echo "export PATH=${M2_HOME}/bin:${PATH}" >>$MAVEN_PROFILE

# chmod
sudo chmod +x $MAVEN_PROFILE

# source file
source $MAVEN_PROFILE

# # check installation
check_program mvn || {
  echo >&2 "Maven program not found.  Aborting."
  exit 1
}

echo "Maven installation succeed!"

# remove tmp
rm -rf $TEMP_FOLDER
