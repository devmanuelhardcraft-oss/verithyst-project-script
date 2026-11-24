#!/usr/bin/env bash
set -Eeuo pipefail

BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "$BASE_DIR/environment.sh"
source "$VERTHYST_SCRIPTS_DIR/language.sh"

RED="\033[1;31m"
BOLD="\033[1m"
UNDER="\033[4m"
RESET="\033[0m"

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
EOF
    echo -e "${RED}${BOLD}${UNDER}0) $EXIT${RESET}"
    echo

    read -r -p "$SELECT " choice || exit 0

    case "$choice" in
        1) bash "$VERTHYST_SCRIPTS_DIR/full-install.sh" ;;
        2) bash "$VERTHYST_SCRIPTS_DIR/gaming.sh" ;;
        3) bash "$VERTHYST_SCRIPTS_DIR/programs.sh" ;;
        4) bash "$VERTHYST_ROOT/flatpaks/flatpak.sh" ;;
        5) bash "$VERTHYST_ROOT/drivers/driver.sh" ;;
        6) clear; echo "$START_KERNEL"; bash "$VERTHYST_KERNELS_DIR/kernel.sh" ;;
        7) clear; echo "$START_OPTIMIZATION"; bash "$VERTHYST_SCRIPTS_DIR/optimization.sh" ;;
        8) clear; echo "$START_UPDATE"; bash "$VERTHYST_SCRIPTS_DIR/update.sh" ;;
        9) clear; echo "$START_CLEANUP"; bash "$VERTHYST_SCRIPTS_DIR/cleanup.sh" ;;
        10) systemctl reboot ;;
        11) systemctl poweroff ;;
        0) echo "$EXIT"; exit 0 ;;
        *) echo "$INVALID"; sleep 2 ;;
    esac
done
