#!/bin/bash

# TODO: https://github.com/kubernetes/community/blob/master/contributors/devel/running-locally.md

# Avoid "unable to re-open stdin: No such file or directory" error
export DEBIAN_FRONTEND=noninteractive

echo "---------------- Setup timezone (Italy) and locale (US English) ----------------"
echo "Europe/Rome" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
    dpkg-reconfigure -f noninteractive locales && \
    update-locale LANG=en_US.UTF-8

echo "---------------- Set 'vagrant' password for 'vagrant' user ----------------"
echo -e "vagrant\nvagrant" | passwd vagrant

apt-get update
# sudo apt-get -y upgrade

# https://github.com/kubernetes/community/blob/master/contributors/devel/development.md#installing-required-software
echo "---------------- Install basic software ----------------"
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    xfce4 \
    git \
    terminator \
    build-essential \
    net-tools \
    rsync \
    openssl \
    jq \
    python3-pip &> /dev/null

# Avoid using Python virtual environments and install pyyaml system-wide
pip install pyyaml --break-system-packages

# Install Docker
echo "---------------- Install Docker ----------------"
readonly DOCKER_URL="https://download.docker.com/linux/debian/dists"
readonly DOCKER_PATH="bookworm/pool/stable/amd64"
readonly -a DOCKER_PACKAGES=(
    "containerd.io_1.6.16-1_amd64.deb"
    "docker-ce-cli_24.0.5-1~debian.12~bookworm_amd64.deb"
    "docker-ce_24.0.5-1~debian.12~bookworm_amd64.deb"
    "docker-buildx-plugin_0.11.2-1~debian.12~bookworm_amd64.deb"
)

pushd /tmp

for PACKAGE in "${DOCKER_PACKAGES[@]}"; do
    curl -Lo $PACKAGE $DOCKER_URL/$DOCKER_PATH/$PACKAGE
    dpkg -i $PACKAGE
done

# rootless Docker
groupadd docker
usermod -aG docker vagrant
newgrp docker

# Install Go
echo "---------------- Install Go ----------------"
readonly GO_VERSION="1.21.1"
readonly GO_PACKAGE="go$GO_VERSION.linux-amd64.tar.gz"
curl -Lo $GO_PACKAGE https://go.dev/dl/$GO_PACKAGE
tar -C /usr/local -xzf $GO_PACKAGE


grep -q "/usr/local/go/bin" /home/vagrant/.profile || \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /home/vagrant/.profile

echo "---------------- Install Chrome browser ----------------"
curl -Lo \
    chrome.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./chrome.deb

popd

apt-get -y autoremove

echo "---------------- About to reboot this VM ----------------"
