#!/usr/bin/env bash

sudo apt-get install -y rsyslog
sudo service rsyslog start

#curl -sLO https://github.com/logzio/logzio-shipper/raw/master/dist/logzio-rsyslog.tar.gz && tar xzf logzio-rsyslog.tar.gz && sudo rsyslog/install.sh -t file -a "EcuhvYttOGesRGgVyRynCRWgiDuUKjWx" -l "listener.logz.io" --filepath "/var/log/syslog" -tag "syslog"

echo "Logging successfully setup"