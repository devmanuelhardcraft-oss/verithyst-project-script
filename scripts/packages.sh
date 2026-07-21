#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst: Programme installieren"
echo "================================="


PACKAGES=(

# Gaming
steam
lutris
bottles
wine
wine-core
winetricks

# Performance
gamemode
mangohud
goverlay
gamescope
vkBasalt

# Vulkan
vulkan-tools
vulkan-loader
mesa-dri-drivers
mesa-vulkan-drivers
mesa-va-drivers

# Streaming
obs-studio

# Entwicklung
git
gcc
gcc-c++
make
cmake
python3
python3-pip

# Tools
curl
wget
unzip
p7zip
nano
vim
htop
fastfetch

# Multimedia Grundpakete
gstreamer1-plugins-base
gstreamer1-plugins-good
gstreamer1-plugins-bad-free

# Netzwerk
NetworkManager-wifi
NetworkManager-bluetooth

)


echo "[+] Installiere Pakete..."

dnf install -y "${PACKAGES[@]}" --skip-unavailable


echo "[+] Aktiviere GameMode..."

systemctl enable --now gamemoded.service 2>/dev/null || true


echo "[OK] Programme installiert"
