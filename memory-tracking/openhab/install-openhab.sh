#!/bin/bash

echo "Preparing repo"

wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | sudo apt-key add -
sudo apt-get install apt-transport-https
echo 'deb https://dl.bintray.com/openhab/apt-repo2 stable main' | sudo tee /etc/apt/sources.list.d/openhab2.list

sudo apt-get update
sudo apt-get install openhab2
sudo apt-get install openhab2-addons
