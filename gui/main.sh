#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Sprache laden
source "$BASE_DIR/scripts/language.sh"

RED="\033[1;31m"
BOLD="\033[1m"
UNDER="\033[4m"
RESET="\033[0m"


while true
do

clear

echo "
██╗   ██╗███████╗██████╗ ████████╗██╗  ██╗██╗   ██╗███████╗████████╗
██║   ██║██╔════╝██╔══██╗╚══██╔══╝██║  ██║╚██╗ ██╔╝██╔════╝╚══██╔══╝
██║   ██║█████╗  ██████╔╝   ██║   ███████║ ╚████╔╝ ███████╗   ██║
╚██╗ ██╔╝██╔══╝  ██╔══██╗   ██║   ██╔══██║  ╚██╔╝  ╚════██║   ██║
 ╚████╔╝ ███████╗██║  ██║   ██║   ██║  ██║   ██║   ███████║   ██║
  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝   ╚═╝

                     $SUBTITLE
"


echo "
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
"

echo -e "${RED}${BOLD}${UNDER}0) $EXIT${RESET}"

echo

read -p "$SELECT " choice


case $choice in

1)
bash "$BASE_DIR/scripts/full-install.sh"
;;

2)
bash "$BASE_DIR/scripts/gaming.sh"
;;

3)
bash "$BASE_DIR/scripts/programs.sh"
;;

4)
bash "$BASE_DIR/flatpaks/flatpak.sh"
;;

5)
bash "$BASE_DIR/drivers/driver.sh"
;;

6)
clear
echo "$START_KERNEL"
bash "$BASE_DIR/kernels/kernel.sh"
;;

7)
clear
echo "$START_OPTIMIZATION"
bash "$BASE_DIR/scripts/optimization.sh"
;;

8)
clear
echo "$START_UPDATE"
bash "$BASE_DIR/scripts/update.sh"
;;

9)
clear
echo "$START_CLEANUP"
bash "$BASE_DIR/scripts/cleanup.sh"
;;

10)
systemctl reboot
;;

11)
systemctl poweroff
;;

0)
echo "$EXIT"
exit 0
;;

*)
echo "$INVALID"
sleep 2
;;

esac

done
