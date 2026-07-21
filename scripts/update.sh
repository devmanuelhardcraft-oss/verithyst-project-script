#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst: System Update"
echo "================================="

echo "[+] Aktualisiere Paketdaten..."

dnf makecache --refresh


echo "[+] System Upgrade..."

dnf upgrade -y


echo "[+] Aktualisiere Firmware..."

if command -v fwupdmgr >/dev/null 2>&1
then
    fwupdmgr refresh --force || true
    fwupdmgr update -y || true
else
    echo "fwupdmgr nicht installiert."
fi


echo "[+] Bereinige DNF..."

dnf autoremove -y || true

dnf clean all


echo "[OK] System aktualisiert"
