#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten."
    exit 1
fi
if ! command -v dnf >/dev/null 2>&1; then
    echo "[FEHLER] DNF wurde nicht gefunden." >&2
    exit 1
fi

GAMING_USER="$VERTHYST_USER"
USER_HOME="$VERTHYST_HOME"
USER_GROUP="$(id -gn "$GAMING_USER")"

echo "================================="
echo " Verthyst: Gaming Setup"
echo " Benutzer: $GAMING_USER"
echo "================================="

echo "[+] Installiere Gaming-Pakete..."
dnf install -y gamemode mangohud gamescope vkBasalt vulkan-tools goverlay steam --skip-unavailable || true

echo "[+] Prüfe GameMode..."
if command -v gamemoded >/dev/null 2>&1; then
    echo "[OK] GameMode installiert"
else
    echo "[WARN] GameMode fehlt"
fi

echo "[+] Prüfe Flatpak..."
if command -v flatpak >/dev/null 2>&1; then
    if ! runuser -u "$GAMING_USER" -- flatpak --user remotes 2>/dev/null | grep -q flathub; then
        echo "[+] Füge Flathub für Benutzer hinzu..."
        runuser -u "$GAMING_USER" -- flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    echo "[+] Installiere ProtonUp-Qt..."
    if runuser -u "$GAMING_USER" -- flatpak --user install -y flathub net.davidotek.pupgui2; then
        echo "[OK] ProtonUp-Qt installiert"
    else
        echo "[WARN] ProtonUp-Qt konnte nicht installiert werden"
    fi
else
    echo "[WARN] Flatpak nicht gefunden"
fi

echo "[+] Erstelle MangoHUD Konfiguration..."
install -d -m 0755 /etc/MangoHud
cat > /etc/MangoHud/MangoHud.conf <<'MANGOEOF'
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
install -d -o "$GAMING_USER" -g "$USER_GROUP" "$USER_HOME/.config/MangoHud" "$USER_HOME/.config/gamemode" "$USER_HOME/.steam/root/compatibilitytools.d"
install -o "$GAMING_USER" -g "$USER_GROUP" -m 0644 /etc/MangoHud/MangoHud.conf "$USER_HOME/.config/MangoHud/MangoHud.conf"
cat > "$USER_HOME/.config/gamemode/gamemode.ini" <<'GAMEEOF'
[general]
renice=10

[cpu]
park_cores=no

[gpu]
apply_gpu_optimisations=yes
GAMEEOF
chown "$GAMING_USER:$USER_GROUP" "$USER_HOME/.config/gamemode/gamemode.ini"
chmod 0644 "$USER_HOME/.config/gamemode/gamemode.ini"

echo
echo "================================="
echo "[OK] Gaming Setup fertig"
echo "================================="
