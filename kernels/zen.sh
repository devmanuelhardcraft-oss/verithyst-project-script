#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"


if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi


echo "================================="
echo " Zen Kernel Vorbereitung"
echo "================================="


CACHE_DIR="$PROJECT_DIR/cache"
SRC_DIR="$CACHE_DIR/kernel-src"

mkdir -p "$SRC_DIR"

cd "$SRC_DIR"


if [ ! -d linux-zen ]; then

git clone \
https://github.com/zen-kernel/zen-kernel.git \
linux-zen

else

cd linux-zen
git pull

fi


echo "Zen Kernel Quelle bereit"
