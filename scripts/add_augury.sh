#!/usr/bin/env bash


git clone https://${DEPLOY_USER}:${DEPLOY_PASS}@gitlab.com/lewisjarednz/augury-wrf /opt/wrf/augury-wrf

# Setup the temporary directory which is where a EBS volume will be mounted
sudo mkdir /mnt/temp
sudo chmod 777 /mnt/temp
