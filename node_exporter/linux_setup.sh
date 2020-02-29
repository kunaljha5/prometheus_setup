#!/bin/bash

## setting node_expoter version to download and setup as linux service.
version=1.0.0-rc.0


## verifying uid is 0

if [[ $(id -u) -eq 0 ]]; then 
  echo "root user allowed to execute this."
else
  echo "Only!! root user is allowed to execute this script"
  exit 1
fi

## installing wget 

yum install wget -y

## making service file for systemctl handling

echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
ExecStart=/opt/node_exporter/node_exporter

[Install]
WantedBy=default.target" >/usr/lib/systemd/system/node_exporter.service


cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v${version}/node_exporter-${version}.linux-amd64.tar.gz
tar -zxvf  node_exporter-1.0.0-rc.0.linux-amd64.tar.gz
mv node_exporter-${version}.linux-amd64 node_exporter

# enabling node_exporter to start at boot
systemctl daemon-reload
systemctl enable node_exporter

systemctl start node_exporter
systemctl status node_exporter
