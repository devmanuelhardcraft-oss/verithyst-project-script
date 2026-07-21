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
--skip-unavailable || true


echo "[+] Prüfe GameMode..."

if systemctl list-unit-files | grep -q gamemoded; then
    systemctl enable --now gamemoded.service || true
else
    echo "GameMode Dienst nicht als Systemdienst vorhanden"
fi


echo "[+] Erstelle MangoHUD Standardprofil..."

mkdir -p /etc/MangoHud

cat > /etc/MangoHud/MangoHud.conf <<MANGOEOF
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
MANGOEOF


echo "[+] Erstelle Benutzer MangoHUD Profil..."

if [ -n "$SUDO_USER" ]; then

    USER_HOME=$(eval echo "~$SUDO_USER")

    mkdir -p "$USER_HOME/.config/MangoHud"

    cp /etc/MangoHud/MangoHud.conf \
    "$USER_HOME/.config/MangoHud/MangoHud.conf"

    chown -R "$SUDO_USER:$SUDO_USER" \
    "$USER_HOME/.config/MangoHud"

fi


echo "[+] Aktiviere CPU Performance Einstellungen..."

cat > /etc/systemd/system/verithyst-gaming.service <<SERVICEEOF
[Unit]
Description=Verithyst Gaming Optimierungen
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c "echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICEEOF


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
