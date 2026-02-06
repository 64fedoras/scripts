#!/bin/bash

# 64fedoras
# Modified: 2024-01-29
# Installs Ubuntu desktop
# Use:  ./install_desktop.sh

# --- --- Install Dependicies --- --- #
apt update && upgrade -y

# --- --- Install XRDP --- --- #
apt install xrdp -y
systemctl enable xrdp
systemctl restart xrdp
systemctl status xrdp | grep Active
sleep 10
print "XRDP active?"

# --- --- Install Desktop --- --- #
apt install ubuntu-desktop-minimal -y
ufw disable
ufw status
sleep 10
print "UFW disabled?"
reboot
