#!/bin/bash

TEMP_FOLDER="temp-maven"
MAVEN_VERSION="3.6.1"
JAVA_DIR="zulu-7-amd64"
DEST_FOLDER="/opt"
MAVEN_PROFILE="/etc/profile.d/maven.sh"

# download maven
wget https://www-us.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz \
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

# check installation
command -v mvn >/dev/null 2>&1 || {
  echo >&2 "Maven installation failed.  Aborting."
  exit 1
}

# remove tmp
rm -rf $TEMP_FOLDER
