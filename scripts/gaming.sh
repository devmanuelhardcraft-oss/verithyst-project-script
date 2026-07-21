#!/usr/bin/env bash

set -e

echo "================================="
echo " Verthyst: Gaming Setup"
echo "================================="

if [ -n "$SUDO_USER" ]; then
    GAMING_USER="$SUDO_USER"
else
    GAMING_USER="$USER"
fi

USER_HOME=$(eval echo "~$GAMING_USER")


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



echo "[+] Erstelle Benutzer Gaming-Konfiguration..."


mkdir -p "$USER_HOME/.config/MangoHud"
mkdir -p "$USER_HOME/.config/gamemode"


cp /etc/MangoHud/MangoHud.conf \
"$USER_HOME/.config/MangoHud/MangoHud.conf"



cat > "$USER_HOME/.config/gamemode/gamemode.ini" <<EOF
[general]
renice=10

[cpu]
park_cores=no

[gpu]
apply_gpu_optimisations=yes
EOF



echo "[+] Bereinige Benutzerrechte..."

chown -R "$GAMING_USER:$GAMING_USER" \
"$USER_HOME/.config/MangoHud" \
"$USER_HOME/.config/gamemode"



echo "[+] Steam Verzeichnis vorbereiten..."

mkdir -p "$USER_HOME/.steam/root/compatibilitytools.d"

chown -R "$GAMING_USER:$GAMING_USER" \
"$USER_HOME/.steam"



echo
echo "[OK] Gaming Setup fertig"
echo
echo "Starte Steam bitte als normaler Benutzer:"
echo "steam"
