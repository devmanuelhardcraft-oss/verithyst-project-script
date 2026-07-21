#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst Gaming Profil"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Bitte mit sudo starten"
    exit 1
fi


echo "[+] Installiere Gaming Pakete..."

dnf install -y \
gamemode \
mangohud \
goverlay \
gamescope \
vkBasalt \
vulkan-tools \
libgamemode


echo "[+] Aktiviere GameMode..."

systemctl enable --now gamemoded.service || true


echo "[+] Erstelle MangoHUD Standardprofil..."

mkdir -p /etc/MangoHud

cat > /etc/MangoHud/MangoHud.conf <<EOF
fps
frametime
cpu_stats
gpu_stats
cpu_temp
gpu_temp
ram
vram
position=top-left
toggle_hud=F12
EOF


echo "[+] Aktiviere CPU Performance Einstellungen..."

mkdir -p /etc/systemd/system

cat > /etc/systemd/system/verithyst-gaming.service <<EOF
[Unit]
Description=Verithyst Gaming Optimierungen
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c "echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable verithyst-gaming.service


echo
echo "================================="
echo " Gaming Profil aktiviert"
echo "================================="

echo
echo "Aktiv:"
echo "- GameMode"
echo "- MangoHUD"
echo "- GOverlay"
echo "- Gamescope"
echo "- vkBasalt"
echo "- Performance Governor"
