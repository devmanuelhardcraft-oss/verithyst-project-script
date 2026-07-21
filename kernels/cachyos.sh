#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi


echo "================================="
echo " CachyOS Kernel Vorbereitung"
echo "================================="


CACHE_DIR="$PROJECT_DIR/cache"
SRC_DIR="$CACHE_DIR/kernel-src"

mkdir -p "$SRC_DIR"


cd "$SRC_DIR"


if [ ! -d linux-cachyos ]; then

    echo "Lade CachyOS Kernel Quellen..."

    git clone \
    https://github.com/CachyOS/linux-cachyos.git

else

    echo "CachyOS Quellen vorhanden"

    cd linux-cachyos

    git pull

fi


echo ""
echo "CachyOS Kernel Quelle bereit:"
echo "$SRC_DIR/linux-cachyos"


echo ""
echo "RPM Build folgt in nächstem Modul."
