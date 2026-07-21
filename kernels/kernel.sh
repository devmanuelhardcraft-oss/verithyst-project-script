#!/bin/bash

set -e

#################################
# VERITHYST KERNEL MANAGER
# CachyOS Kernel + Zen Fallback
#################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

KERNEL_RPM_DIR="$BASE_DIR/packages/kernel/rpms"

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"


check_root()
{
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Bitte mit sudo starten${NC}"
        exit 1
    fi
}


header()
{
clear

echo "================================="
echo " VERITHYST KERNEL MANAGER"
echo " CachyOS + Zen + Fedora"
echo "================================="
echo
}


install_dependencies()
{
echo
echo "Installiere Abhängigkeiten..."

dnf install -y \
git \
curl \
wget \
dnf-plugins-core \
grubby \
kernel-tools
}


install_cachy()
{

echo
echo "================================="
echo " CachyOS Kernel Installation"
echo "================================="


if ls "$KERNEL_RPM_DIR"/*.rpm >/dev/null 2>&1
then

echo "Lokales Verithyst Kernel RPM gefunden"

dnf install -y \
"$KERNEL_RPM_DIR"/*.rpm \
--allowerasing


else

echo "Kein fertiges Kernel RPM vorhanden"

echo
echo "CachyOS Kernel Quelle vorbereiten..."

mkdir -p "$BASE_DIR/cache"

cd "$BASE_DIR/cache"


if [ ! -d linux-cachyos ]
then

git clone \
https://github.com/CachyOS/linux-cachyos.git

else

cd linux-cachyos
git pull
cd ..

fi


echo
echo "CachyOS Quellen geladen."

echo
echo "Kernel Build muss noch integriert werden."

fi


}


install_zen()
{

echo
echo "================================="
echo " Zen Kernel Installation"
echo "================================="


dnf install -y kernel-zen \
|| echo "Zen Kernel nicht in Fedora verfügbar"


}


install_fedora()
{

echo
echo "================================="
echo " Fedora Fallback Kernel"
echo "================================="


dnf install -y kernel kernel-core kernel-modules


}


update_grub()
{

echo
echo "Aktualisiere GRUB..."

if [ -d /sys/firmware/efi ]
then

grub2-mkconfig \
-o /boot/efi/EFI/fedora/grub.cfg \
|| grub2-mkconfig -o /boot/grub2/grub.cfg

else

grub2-mkconfig \
-o /boot/grub2/grub.cfg

fi


}


set_default_kernel()
{

echo
echo "Setze bevorzugten Kernel..."

DEFAULT=$(grubby --info=ALL | grep "^kernel=" | head -1 | cut -d= -f2)


if [ -n "$DEFAULT" ]
then

grubby --set-default "$DEFAULT"

echo "Standard gesetzt:"
echo "$DEFAULT"

else

echo "Kein Kernel gefunden"

fi


}


install_all()
{

install_dependencies

install_fedora

install_zen

install_cachy

update_grub

set_default_kernel


echo
echo "================================="
echo " Kernel Setup abgeschlossen"
echo "================================="

}


menu()
{

while true
do

header


echo "1) CachyOS Kernel installieren"
echo "2) Zen Kernel installieren"
echo "3) Fedora Fallback installieren"
echo "4) Alle installieren"
echo "5) GRUB aktualisieren"
echo "6) Standard Kernel setzen"
echo "0) Zurück"
echo


read -p "Auswahl: " choice


case $choice in

1)
install_cachy
;;

2)
install_zen
;;

3)
install_fedora
;;

4)
install_all
;;

5)
update_grub
;;

6)
set_default_kernel
;;

0)
exit 0
;;

*)
echo "Ungültige Auswahl"
;;

esac


read -p "Enter drücken..."

done

}


#################################
# START
#################################

check_root


if [ -z "$1" ]
then

menu

else

case "$1" in

cachy)
install_cachy
;;

zen)
install_zen
;;

fedora)
install_fedora
;;

all)
install_all
;;

grub)
update_grub
;;

default)
set_default_kernel
;;

*)
echo "Benutzung:"
echo
echo "$0 cachy"
echo "$0 zen"
echo "$0 fedora"
echo "$0 all"
echo "$0 grub"
echo "$0 default"
;;

esac

fi
