#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten" >&2
    exit 1
fi

echo "================================="
echo " Verthyst System-Aufräumen"
echo "================================="
echo "Es werden Paket-Caches, nicht benötigte Pakete und alte Journal-Einträge bereinigt."
echo "Temporäre Systemdateien und installierte Kernel bleiben unangetastet."
read -r -p "Fortfahren? [j/N] " answer
[[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || { echo "Abgebrochen."; exit 0; }

echo "[+] Bereinige DNF Cache..."
dnf clean all

echo "[+] Entferne nicht benötigte Pakete..."
dnf autoremove -y || true

echo "[+] Bereinige nicht verwendete Flatpaks..."
if command -v flatpak >/dev/null 2>&1; then
    flatpak uninstall --unused -y || true
    if command -v runuser >/dev/null 2>&1; then
        runuser -u "$VERTHYST_USER" -- env HOME="$VERTHYST_HOME" flatpak --user uninstall --unused -y || true
    fi
fi

echo "[+] Begrenze System-Journal auf 14 Tage..."
journalctl --vacuum-time=14d || true

echo "[+] Bereinige Thumbnail-Cache von $VERTHYST_USER..."
THUMBNAIL_DIR="$VERTHYST_HOME/.cache/thumbnails"
if [[ -d "$THUMBNAIL_DIR" ]]; then
    find "$THUMBNAIL_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
fi

echo
echo "[OK] Aufräumen abgeschlossen."
