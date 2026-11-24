#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten." >&2
    exit 1
fi
command -v dnf >/dev/null 2>&1 || { echo "[FEHLER] DNF nicht gefunden." >&2; exit 1; }
command -v rpm >/dev/null 2>&1 || { echo "[FEHLER] RPM nicht gefunden." >&2; exit 1; }

FEDORA_VERSION="$(rpm -E %fedora)"
[[ "$FEDORA_VERSION" =~ ^[0-9]+$ ]] || { echo "[FEHLER] Fedora-Version konnte nicht ermittelt werden." >&2; exit 1; }

echo "================================="
echo " Verthyst: Repositories"
echo "================================="
echo "RPM Fusion Free und Nonfree werden für Fedora $FEDORA_VERSION aktiviert."
read -r -p "Fortfahren? [j/N] " answer
[[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || { echo "Abgebrochen."; exit 0; }

dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

if command -v flatpak >/dev/null 2>&1; then
    flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo "[INFO] Flatpak ist noch nicht installiert; Flathub wurde übersprungen."
fi

dnf makecache --refresh
echo "[OK] Repositories eingerichtet."
