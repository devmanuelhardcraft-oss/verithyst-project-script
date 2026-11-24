#!/usr/bin/env bash
set -Eeuo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "$BASE_DIR/environment.sh"
source "$VERTHYST_SCRIPTS_DIR/language.sh"

RED="\033[1;31m"
BOLD="\033[1m"
UNDER="\033[4m"
RESET="\033[0m"

run_module() {
    local path="$1"
    if [[ ! -f "$path" ]]; then
        echo "[FEHLER] Modul nicht gefunden: $path" >&2
        read -r -p "ENTER zum Zurückkehren..." _ || true
        return 1
    fi
    bash "$path" || {
        local status=$?
        echo "[FEHLER] Modul mit Exit-Code $status beendet." >&2
        read -r -p "ENTER zum Zurückkehren..." _ || true
        read -r -p "ENTER zum Menü..." _ || true
    }
    return 0
}

while true; do
    clear
    cat <<EOF
██╗   ██╗███████╗██████╗ ████████╗██╗  ██╗██╗   ██╗███████╗████████╗
██║   ██║██╔════╝██╔══██╗╚══██╔══╝██║  ██║╚██╗ ██╔╝██╔════╝╚══██╔══╝
██║   ██║█████╗  ██████╔╝   ██║   ███████║ ╚████╔╝ ███████╗   ██║
╚██╗ ██╔╝██╔══╝  ██╔══██╗   ██║   ██╔══██║  ╚██╔╝  ╚════██║   ██║
 ╚████╔╝ ███████╗██║  ██║   ██║   ██║  ██║   ██║   ███████║   ██║
  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝   ╚═╝

                     $SUBTITLE

=================================
       $TITLE
=================================

1) $MENU_1
2) $MENU_2
3) $MENU_3
4) $MENU_4
5) $MENU_5
6) $MENU_6
7) $MENU_7
8) $MENU_8
9) $MENU_9

10) $MENU_10
11) $MENU_11
12) $MENU_12
EOF
    echo -e "${RED}${BOLD}${UNDER}0) $EXIT${RESET}"
    echo

    read -r -p "$SELECT " choice || exit 0
    case "$choice" in
        1) run_module "$VERTHYST_SCRIPTS_DIR/full-install.sh" ;;
        2) run_module "$VERTHYST_SCRIPTS_DIR/gaming.sh" ;;
        3) run_module "$VERTHYST_SCRIPTS_DIR/packages.sh" ;;
        4) run_module "$VERTHYST_ROOT/flatpaks/flatpak.sh" ;;
        5) run_module "$VERTHYST_ROOT/drivers/driver.sh" ;;
        6) run_module "$VERTHYST_KERNELS_DIR/kernel.sh" ;;
        7) run_module "$VERTHYST_SCRIPTS_DIR/optimization.sh" ;;
        8) run_module "$VERTHYST_SCRIPTS_DIR/update.sh" ;;
        9) run_module "$VERTHYST_SCRIPTS_DIR/cleanup.sh" ;;
        10) read -r -p "System wirklich neu starten? [j/N] " answer; [[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] && systemctl reboot ;;
        11) read -r -p "System wirklich herunterfahren? [j/N] " answer; [[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] && systemctl poweroff ;;
        12) run_module "$VERTHYST_SCRIPTS_DIR/diagnostics.sh" ;;
        0) echo "$EXIT"; exit 0 ;;
        *) echo "$INVALID"; sleep 2 ;;
    esac
done
