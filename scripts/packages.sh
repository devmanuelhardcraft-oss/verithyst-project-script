#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten." >&2
    exit 1
fi
command -v dnf >/dev/null 2>&1 || { echo "[FEHLER] DNF nicht gefunden." >&2; exit 1; }

PACKAGES=(
    steam lutris bottles wine wine-core winetricks
    gamemode mangohud goverlay gamescope vkBasalt
    vulkan-tools vulkan-loader mesa-dri-drivers mesa-vulkan-drivers mesa-va-drivers
    obs-studio
    git gcc gcc-c++ make cmake python3 python3-pip
    curl wget unzip p7zip nano vim htop fastfetch
    gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free
    NetworkManager-wifi NetworkManager-bluetooth
)

echo "================================="
echo " Verthyst: Programme installieren"
echo "================================="
echo "Es werden optionale Gaming-, Multimedia- und Entwicklerpakete installiert."
read -r -p "Fortfahren? [j/N] " answer
[[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || { echo "Abgebrochen."; exit 0; }

echo "[+] Installiere verfügbare Pakete..."
dnf install -y --skip-unavailable "${PACKAGES[@]}"

echo "[OK] Paketinstallation abgeschlossen."
