#!/bin/bash

# 64fedoras
# Modified: 2026-02-16
# Finds the old hostname in hostname and hosts files and replaces it with the new
# Use:  ./change_hostname.sh old-hostname new-hostname

#check if two arguments are provided
if [ "$#" -ne 2 ]; then
        echo "Usage: $0 old_string new_string"
        exit 1
fi

# Run sed command to replace old_string with new_string in /etc/hosts and /etc/hostname
sed -i "s/$1/$2/" /etc/hosts /etc/hostname

# Change the system hostname to new_string
hostname $2
