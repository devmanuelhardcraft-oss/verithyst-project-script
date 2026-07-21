#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi


echo "================================="
echo " Verithyst Kernel RPM Builder"
echo "================================="


BUILD_DIR="$PROJECT_DIR/packages/kernel"


mkdir -p "$BUILD_DIR"


echo "Installiere RPM Build Werkzeuge..."


dnf install -y \
rpm-build \
rpmdevtools \
gcc \
make \
bc \
openssl-devel \
elfutils-libelf-devel \
ncurses-devel \
bison \
flex \
perl


echo ""
echo "Kernel Quellen:"


echo "$PROJECT_DIR/cache/kernel-src"


echo ""
echo "Vorbereitung abgeschlossen."


echo ""
echo "Nächster Schritt:"
echo "SPEC Datei für CachyOS Kernel hinzufügen."
