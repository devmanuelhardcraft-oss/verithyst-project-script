#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst: Gaming Setup"
echo "================================="


echo "[+] Installiere Gaming-Pakete..."


dnf install -y \
gamemode \
mangohud \
gamescope \
vkBasalt \
vulkan-tools \
goverlay \
steam \
--skip-unavailable || true



echo "[+] Aktiviere GameMode..."


systemctl enable --now gamemoded.service 2>/dev/null || true



echo "[+] Erstelle MangoHud Konfiguration..."


mkdir -p /etc/MangoHud


cat > /etc/MangoHud/MangoHud.conf <<EOF
legacy_layout=false

fps
frametime
cpu_stats
gpu_stats
gpu_temp
cpu_temp
ram
vram

position=top-left

toggle_hud=Shift_R+F12
EOF



echo "[+] Erstelle Benutzer Gaming-Verzeichnisse..."


for USER_HOME in /home/*
do

if [ -d "$USER_HOME" ]
then

USER=$(basename "$USER_HOME")

mkdir -p "$USER_HOME/.config/MangoHud"
mkdir -p "$USER_HOME/.config/gamemode"

cp /etc/MangoHud/MangoHud.conf \
"$USER_HOME/.config/MangoHud/MangoHud.conf" || true


cat > "$USER_HOME/.config/gamemode/gamemode.ini" <<EOF
[general]
renice=10

[cpu]
park_cores=no

[gpu]
apply_gpu_optimisations=yes
EOF


chown -R "$USER:$USER" \
"$USER_HOME/.config/MangoHud" \
"$USER_HOME/.config/gamemode" 2>/dev/null || true

fi

done



echo "[+] Proton Verzeichnis vorbereiten..."

for USER_HOME in /home/*
do

if [ -d "$USER_HOME" ]
then

mkdir -p "$USER_HOME/.steam/root/compatibilitytools.d"

fi

done



echo
echo "[OK] Gaming Setup fertig"
