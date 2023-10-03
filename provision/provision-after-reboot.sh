#!/bin/bash

cd /home/vagrant

# gcloud
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-448.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-448.0.0-linux-x86_64.tar.gz
echo -e "n\ny\n" | ./google-cloud-sdk/install.sh

# CRI-O
echo "---------------- Install CRI-O ----------------"
curl https://raw.githubusercontent.com/cri-o/cri-o/main/scripts/get | sudo bash
sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio

# CFSSL
go install github.com/cloudflare/cfssl/cmd/...@latest
echo "PATH=$PATH:$GOPATH/bin" >> /home/vagrant/.profile
echo "PATH=$PATH:$GOPATH/bin" >> /home/vagrant/.bashrc
