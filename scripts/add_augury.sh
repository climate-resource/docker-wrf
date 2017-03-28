#!/usr/bin/env bash

# Make sure that the permissions on the ssh keys are correct
chmod 600 ~/.ssh/id_rsa

ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts

git clone git@gitlab.com:lewisjarednz/augury-wrf.git /opt/wrf/augury-wrf

# Setup the temporary directory which is where a EBS volume will be mounted
sudo mkdir /mnt/temp
sudo chmod 777 /mnt/temp
