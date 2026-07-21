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


echo "[+] Prüfe GameMode..."

if command -v gamemoded >/dev/null 2>&1; then
    echo "[OK] GameMode installiert"
else
    echo "[WARN] GameMode fehlt"
fi


echo "[+] Prüfe Flatpak..."

if command -v flatpak >/dev/null 2>&1; then

    if ! sudo -u "$GAMING_USER" flatpak --user remotes | grep -q flathub; then

        echo "[+] Füge Flathub für Benutzer hinzu..."

        sudo -u "$GAMING_USER" flatpak --user remote-add \
        --if-not-exists \
        flathub \
        https://flathub.org/repo/flathub.flatpakrepo

    fi


    echo "[+] Installiere ProtonUp-Qt..."

    if sudo -u "$GAMING_USER" flatpak --user install -y \
    flathub net.davidotek.pupgui2; then

        echo "[OK] ProtonUp-Qt installiert"

    else

        echo "[WARN] ProtonUp-Qt konnte nicht installiert werden"

    fi


else

    echo "[WARN] Flatpak nicht gefunden"

fi



echo "[+] Erstelle MangoHUD Konfiguration..."

mkdir -p /etc/MangoHud

cat > /etc/MangoHud/MangoHud.conf <<MANGOEOF
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
MANGOEOF



echo "[+] Erstelle Benutzer Gaming-Konfiguration..."

mkdir -p "$USER_HOME/.config/MangoHud"
mkdir -p "$USER_HOME/.config/gamemode"


cp /etc/MangoHud/MangoHud.conf \
"$USER_HOME/.config/MangoHud/MangoHud.conf"


cat > "$USER_HOME/.config/gamemode/gamemode.ini" <<GAMEEOF
[general]
renice=10

[cpu]
park_cores=no

[gpu]
apply_gpu_optimisations=yes
GAMEEOF



echo "[+] Repariere Benutzerrechte..."

chown -R "$GAMING_USER:$GAMING_USER" \
"$USER_HOME/.config/MangoHud" \
"$USER_HOME/.config/gamemode" 2>/dev/null || true


mkdir -p "$USER_HOME/.steam/root/compatibilitytools.d"

chown -R "$GAMING_USER:$GAMING_USER" \
"$USER_HOME/.steam" 2>/dev/null || true



echo
echo "================================="
echo "[OK] Gaming Setup fertig"
echo "================================="
