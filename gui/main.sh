#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

                     Gaming Linux Setup
"


echo "
=================================
       VERTHYST-SCRIPT
=================================

1) Komplettinstallation
2) Gaming Setup
3) Programme installieren
4) Flatpaks installieren
5) Treiber installieren
6) Kernel installieren
7) System optimieren
8) Updates
9) Aufräumen

10) Neu starten
11) Herunterfahren
"

echo -e "${RED}${BOLD}${UNDER}0) BEENDEN (NICHT EMPFOHLEN)${RESET}"

echo

read -p "Auswahl: " choice


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
bash "$BASE_DIR/kernels/kernel.sh"
;;

7)
bash "$BASE_DIR/scripts/optimization.sh"
;;

8)
bash "$BASE_DIR/scripts/update.sh"
;;

9)
bash "$BASE_DIR/scripts/cleanup.sh"
;;

10)
systemctl reboot
;;

11)
systemctl poweroff
;;

0)
echo "Verthyst-Script beendet."
exit 0
;;

*)
echo "Ungültige Auswahl"
sleep 2
;;

esac

done
