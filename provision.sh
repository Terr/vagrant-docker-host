#!/bin/bash

# Update packages
pacman -S --sysupgrade --refresh --noconfirm

# Was the kernel upgraded?
#if [[ $(pacman -Q linux | cut -d " " -f 2 | sed 's/-/./g') != $(uname -r | sed 's/-/./g') ]]; then
    #echo Kernel was upgraded, rebooting...
    #reboot
#fi

# Ensure Docker is installed
if [ ! "$(pacman -Q docker)" ]; then
    pacman -S --noconfirm docker pigz

    # Let Docker listen on all interfaces
    sed --in-place='.bak' --regexp-extended 's/ExecStart=(.*)/ExecStart=\1 -H tcp:\/\/0.0.0.0:2375/' /usr/lib/systemd/system/docker.service

    systemctl daemon-reload
    systemctl enable docker

    # Add 'vagrant' user to group 'docker' because 'sudo' is password-less
    # anyway
    usermod -G docker vagrant
fi

echo VM will be rebooted by Vagrant
