#!/bin/bash


if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi


echo "Installiere Fedora Fallback Kernel"


dnf install -y \
kernel \
kernel-core \
kernel-modules \
kernel-modules-extra


echo "Fedora Kernel installiert"
