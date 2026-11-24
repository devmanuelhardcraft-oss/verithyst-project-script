#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte über den Installer mit sudo starten." >&2
    exit 1
fi

echo "================================="
echo " Verthyst Komplettinstallation"
echo "================================="
echo "Projekt: $VERTHYST_ROOT"
echo "Benutzer: $VERTHYST_USER"
echo
echo "Die Installation verändert Pakete und Systemeinstellungen."
read -r -p "Fortfahren? [j/N] " answer
[[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || { echo "Abgebrochen."; exit 0; }

run_module() {
    local module="$1"
    local path="$VERTHYST_SCRIPTS_DIR/$module"
    echo
    echo "================================="
    echo " Starte $module"
    echo "================================="
    if [[ ! -f "$path" ]]; then
        echo "[FEHLER] Modul fehlt: $path" >&2
        return 1
    fi
    if bash "$path"; then
        echo "[OK] $module abgeschlossen"
    else
        local status=$?
        echo "[FEHLER] $module fehlgeschlagen (Exit $status)." >&2
        read -r -p "Mit dem nächsten Modul fortfahren? [j/N] " answer
        [[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || exit "$status"
    fi
}

run_module repos.sh
run_module update.sh
run_module packages.sh
run_module gaming.sh
run_module optimization.sh

echo
echo "================================="
echo " Verthyst Installation beendet"
echo "================================="
echo "Treiber und Kernel werden bewusst separat verwaltet."
read -r -p "ENTER zum Beenden..." _ || true
