#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst: Repositories"
echo "================================="

echo "[+] Prüfe Fedora..."

if ! command -v dnf >/dev/null 2>&1
then
    echo "DNF nicht gefunden. Abbruch."
    exit 1
fi


echo "[+] Aktiviere RPM Fusion Free..."

dnf install -y \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm


echo "[+] Aktiviere RPM Fusion Nonfree..."

dnf install -y \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


echo "[+] Aktiviere Flathub..."

if command -v flatpak >/dev/null 2>&1
then

flatpak remote-add \
--if-not-exists \
flathub \
https://flathub.org/repo/flathub.flatpakrepo

else

echo "Flatpak fehlt, wird später installiert."

fi


echo "[+] Aktualisiere Paketquellen..."

dnf makecache


echo
echo "[OK] Repositories fertig"
echo
