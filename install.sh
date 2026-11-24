#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="1.1"
BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# Root is needed for system packages, but resolve the project path before sudo.
if [[ $EUID -ne 0 ]]; then
    if ! command -v sudo >/dev/null 2>&1; then
        echo "[FEHLER] sudo ist nicht installiert." >&2
        exit 1
    fi
    exec sudo -- bash "$BASE_DIR/install.sh" "$@"
fi

# Shared environment is also used by modules and the GUI.
source "$BASE_DIR/environment.sh"

mkdir -p "$VERTHYST_LOG_DIR"
LOGFILE="$VERTHYST_LOG_DIR/install.log"
exec > >(tee -a "$LOGFILE") 2>&1

trap 'status=$?; echo "[FEHLER] Installer abgebrochen (Zeile $LINENO, Exit $status)."; exit "$status"' ERR

echo "================================="
echo "      VERTHYST-SCRIPT INSTALLER"
echo "      Version $VERSION"
echo "================================="

check_internet() {
    echo "[+] Prüfe Internet..."
    if command -v curl >/dev/null 2>&1; then
        curl --fail --silent --show-error --max-time 10 https://fedoraproject.org/ >/dev/null
    elif command -v ping >/dev/null 2>&1; then
        ping -c 1 fedoraproject.org >/dev/null
    else
        echo "[FEHLER] Weder curl noch ping verfügbar." >&2
        return 1
    fi
    echo "[OK] Internet verfügbar"
}

install_dependencies() {
    if ! command -v dnf >/dev/null 2>&1; then
        echo "[FEHLER] Dieses Installationsskript benötigt Fedora oder eine DNF-basierte Distribution." >&2
        return 1
    fi

    echo "[+] Installiere Grundabhängigkeiten..."
    dnf install -y dialog curl wget git flatpak unzip tar rsync
}

load_gui() {
    if [[ -f "$VERTHYST_GUI_DIR/main.sh" ]]; then
        bash "$VERTHYST_GUI_DIR/main.sh"
    else
        echo "[FEHLER] GUI nicht gefunden: $VERTHYST_GUI_DIR/main.sh" >&2
        return 1
    fi
}

main() {
    check_internet
    install_dependencies
    load_gui
}

main "$@"
