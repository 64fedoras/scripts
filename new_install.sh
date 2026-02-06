#!/bin/bash

# 64fedoras
# Modified: 2026-02-06
# Sets a VM to be ready for use
# Use:  ./new_install.sh old-hostname new-hostname

# --- --- Change Hostname --- --- #
# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
        echo "Usage: $0 old_string new_string"
        exit 1
fi

# Run sed command to replace old_string with new_string in /etc/hosts and /etc/hostname
sed -i "s/$1/$2/" /etc/hosts /etc/hostname

# Change the system hostname to new_string
hostname $2


# --- --- Extend LVM --- --- #
printf "\nExpanding LVM..."
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%free /dev/ubuntu-vg/ubuntu-lv && wait && resize2fs /dev/ubuntu-vg/ubuntu-lv
# --- --- Remove Boot Network Wait --- --- #
printf "\nRemoving network wait on boot..."
systemctl mask systemd-networkd-wait-online.service
printf "\n\n\n\n\n"

# --- --- Update and Install Dependencies --- --- #
printf "\nUpdating Apt..."
#apt update -y
apt update
printf "\n\n\n\n\n"


printf "Installing Dependencies... \n"
sleep 2
apt install curl isc-dhcp-client nfs-common cifs-utils qemu-guest-agent -y
printf "\n\n\n\n\n"


printf "Cleaning up... \n"
apt autoremove -y
apt autoclean -y
printf "\nCleaned"
printf "\n\n\n\n\n"


# --- --- Reset Machine ID --- --- #
printf "Resetting Machine ID... \n"
sleep 1
rm -f /etc/machine-id
dbus-uuidgen --ensure=/etc/machine-id
rm /var/lib/dbus/machine-id
dbus-uuidgen --ensure
dhclient -r

while true; do
    read -p "\n\nMachine id reset, a reboot is required. Would you like to reboot now? (y/n) " yn # Prompt with a question.
    case $yn in
        [Yy]* ) reboot now;; # Break the loop if user input is yes.
        [Nn]* ) break;; # Exit from script if no.
        * ) echo "Please answer yes (y/Y) or no (n/N).";; # Re-ask question for other inputs.
    esac
done
# --- --- --- --- #
