#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten." >&2
    exit 1
fi
command -v flatpak >/dev/null 2>&1 || { echo "[FEHLER] Flatpak fehlt. Installiere es zuerst über die Paketverwaltung." >&2; exit 1; }

echo "================================="
echo " Verthyst: Flatpak Manager"
echo "================================="
echo "Benutzer: $VERTHYST_USER"
echo "1) Flathub systemweit aktivieren"
echo "2) Flatpak-Anwendungen installieren"
echo "3) Nicht verwendete Flatpaks entfernen"
echo "0) Zurück"
read -r -p "Auswahl: " choice

case "$choice" in
    1)
        flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        echo "[OK] Flathub ist eingerichtet."
        ;;
    2)
        flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        echo "Verfügbare Apps (IDs):"
        echo "  com.valvesoftware.Steam"
        echo "  net.lutris.Lutris"
        echo "  com.usebottles.bottles"
        echo "  com.obsproject.Studio"
        echo "  net.davidotek.pupgui2"
        read -r -p "App-ID eingeben (leer = Abbrechen): " app_id
        [[ -n "$app_id" ]] || { echo "Abgebrochen."; exit 0; }
        [[ "$app_id" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "[FEHLER] Ungültige App-ID." >&2; exit 2; }
        flatpak install --system --assumeyes flathub "$app_id"
        ;;
    3)
        flatpak uninstall --system --unused --assumeyes
        runuser -u "$VERTHYST_USER" -- env HOME="$VERTHYST_HOME" flatpak uninstall --user --unused --assumeyes || true
        ;;
    0) exit 0 ;;
    *) echo "Ungültige Auswahl."; exit 2 ;;
esac
