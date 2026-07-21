#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst System Aufräumen"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Bitte mit sudo starten"
    exit 1
fi


echo "[+] Bereinige DNF Cache..."

dnf clean all


echo "[+] Entferne nicht benötigte Pakete..."

dnf autoremove -y || true


echo "[+] Bereinige alte RPM Daten..."

dnf repoquery --installonly --latest-limit=-2 -q | xargs -r dnf remove -y || true


echo "[+] Bereinige temporäre Dateien..."

rm -rf /tmp/*
rm -rf /var/tmp/*


echo "[+] Bereinige Flatpak Reste..."

if command -v flatpak >/dev/null 2>&1
then
    flatpak uninstall --unused -y || true
fi


echo "[+] Begrenze System Logs..."

journalctl --vacuum-time=14d || true


echo "[+] Bereinige Thumbnail Cache..."

rm -rf /home/*/.cache/thumbnails/* 2>/dev/null || true


echo
echo "================================="
echo " Aufräumen abgeschlossen"
echo "================================="
