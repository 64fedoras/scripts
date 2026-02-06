#!/bin/bash

# 64fedoras
# Modified: 2026-02-06
# Expands LVM to use all free disk space, run after increasing  disk size in promox
# Use:  ./extend_lvm

# --- --- Extend LVM --- --- #
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%free /dev/ubuntu-vg/ubuntu-lv && wait && resize2fs /dev/ubuntu-vg/ubuntu-lv
