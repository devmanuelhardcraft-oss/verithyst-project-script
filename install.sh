#!/usr/bin/env bash

set -e

VERSION="1.0"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG_DIR="$BASE_DIR/logs"
SCRIPT_DIR="$BASE_DIR/scripts"
GUI_DIR="$BASE_DIR/gui"
CONFIG_DIR="$BASE_DIR/config"

mkdir -p "$LOG_DIR"

LOGFILE="$LOG_DIR/install.log"

exec > >(tee -a "$LOGFILE") 2>&1


echo "================================="
echo "      VERTHYST-SCRIPT INSTALLER"
echo "      Version $VERSION"
echo "================================="


check_root()
{
    if [ "$EUID" -ne 0 ]; then
        echo "Starte mit sudo..."

        exec sudo bash "$BASE_DIR/install.sh" "$@"
    fi
}


check_internet()
{
    echo "[+] Prüfe Internet..."

    if ping -c 1 fedoraproject.org >/dev/null 2>&1
    then
        echo "[OK] Internet verfügbar"
    else
        echo "[FEHLER] Keine Internetverbindung"
        exit 1
    fi
}


install_dependencies()
{
    echo "[+] Installiere Grundabhängigkeiten..."

    dnf install -y \
    dialog \
    curl \
    wget \
    git \
    flatpak \
    unzip \
    tar \
    rsync
}


load_gui()
{
    if [ -f "$GUI_DIR/main.sh" ]
    then
        bash "$GUI_DIR/main.sh"
    else
        echo "GUI nicht gefunden!"
        exit 1
    fi
}


main()
{
    check_root "$@"

    check_internet

    install_dependencies

    load_gui
}


main "$@"
