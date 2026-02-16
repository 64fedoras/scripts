#!/bin/bash

# 64fedoras
# Modified: 2026-02-16
# Sets up dockge to be ready for use on [IP]:5001
# Use:  ./install_dockge.sh

# --- --- Add Official Docker GPG Key --- --- #
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# --- --- Add Repo to Apt Sources --- --- #
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# --- --- Install Docker Compose --- --- #
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# --- --- Create Dockge Directories --- --- #
sudo mkdir -p /opt/stacks /opt/dockge && cd /opt/dockge

# --- --- Download Dockge YAML --- --- #
cd /opt/dockge
sudo curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# --- --- Start Dockge --- --- #
sudo docker compose up -d
docker compose ls
