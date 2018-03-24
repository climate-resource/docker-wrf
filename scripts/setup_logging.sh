#!/usr/bin/env bash

ES_VERSION=6.2.3

# Install filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ES_VERSION}-amd64.deb
sudo dpkg -i filebeat-${ES_VERSION}-amd64.deb
rm filebeat-${ES_VERSION}-amd64.deb

# Install metricbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${ES_VERSION}-amd64.deb
sudo dpkg -i metricbeat-${ES_VERSION}-amd64.deb
rm metricbeat-${ES_VERSION}-amd64.deb

echo "Logging successfully setup"