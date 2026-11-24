#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

echo "================================="
echo " Verthyst System Aufräumen"
echo "================================="

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten" >&2
    exit 1
fi

echo "[+] Bereinige DNF Cache..."
dnf clean all

echo "[+] Entferne nicht benötigte Pakete..."
dnf autoremove -y || true

echo "[+] Bereinige alte RPM Daten..."
dnf repoquery --installonly --latest-limit=-2 -q | xargs -r dnf remove -y || true

echo "[+] Bereinige temporäre Dateien..."
# Leave the system temporary directories themselves intact.
find /tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
find /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +

echo "[+] Bereinige Flatpak Reste..."
if command -v flatpak >/dev/null 2>&1; then
    flatpak uninstall --unused -y || true
fi

echo "[+] Begrenze System Logs..."
journalctl --vacuum-time=14d || true

echo "[+] Bereinige Thumbnail Cache von $VERTHYST_USER..."
THUMBNAIL_DIR="$VERTHYST_HOME/.cache/thumbnails"
if [[ -d "$THUMBNAIL_DIR" ]]; then
    find "$THUMBNAIL_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
fi

echo
echo "================================="
echo " Aufräumen abgeschlossen"
echo "================================="
