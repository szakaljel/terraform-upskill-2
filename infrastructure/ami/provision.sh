#!/bin/bash
sudo apt-get update
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get install -y unzip python3.8 python3-pip

mkdir tu
unzip build.zip -d tu
cd tu

sudo python3.8 -m pip install -r requirements.txt
sudo cp /home/ubuntu/web.service.tpl /etc/systemd/system/tu.service
sudo systemctl enable tu.service