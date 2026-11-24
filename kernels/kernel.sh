#!/usr/bin/env bash
set -Eeuo pipefail

#################################
# VERTHYST KERNEL MANAGER
# CachyOS Kernel + Zen Fallback
#################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"
KERNEL_RPM_DIR="$VERTHYST_PACKAGES_DIR/kernel/rpms"
CACHE_DIR="$VERTHYST_ROOT/cache"

RED="\033[0;31m"
NC="\033[0m"

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Bitte mit sudo starten${NC}" >&2
        exit 1
    fi
}

header() {
    clear
    echo "================================="
    echo " VERITHYST KERNEL MANAGER"
    echo " CachyOS + Zen + Fedora"
    echo "================================="
    echo
}

install_dependencies() {
    echo
    echo "Installiere Abhängigkeiten..."
    dnf install -y git curl wget dnf-plugins-core grubby kernel-tools
}

install_cachy() {
    echo
    echo "================================="
    echo " CachyOS Kernel Installation"
    echo "================================="

    shopt -s nullglob
    local rpms=("$KERNEL_RPM_DIR"/*.rpm)
    shopt -u nullglob
    if (("${#rpms[@]}" > 0)); then
        echo "Lokales Verithyst Kernel RPM gefunden"
        dnf install -y "${rpms[@]}" --allowerasing
        return
    fi

    echo "Kein fertiges Kernel RPM vorhanden"
    echo "CachyOS Kernel Quelle vorbereiten..."
    mkdir -p "$CACHE_DIR"
    if [[ ! -d "$CACHE_DIR/linux-cachyos/.git" ]]; then
        git clone https://github.com/CachyOS/linux-cachyos.git "$CACHE_DIR/linux-cachyos"
    else
        git -C "$CACHE_DIR/linux-cachyos" pull --ff-only
    fi
    echo
    echo "CachyOS Quellen geladen."
    echo "Kernel Build muss noch integriert werden."
}

install_zen() {
    echo
    echo "================================="
    echo " Zen Kernel Installation"
    echo "================================="
    dnf install -y kernel-zen || echo "Zen Kernel nicht in Fedora verfügbar"
}

install_fedora() {
    echo
    echo "================================="
    echo " Fedora Fallback Kernel"
    echo "================================="
    dnf install -y kernel kernel-core kernel-modules
}

update_grub() {
    echo
    echo "Aktualisiere GRUB..."
    if [[ -d /sys/firmware/efi ]]; then
        grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg || grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
}

set_default_kernel() {
    echo
    echo "Setze bevorzugten Kernel..."
    local default_kernel
    default_kernel="$(grubby --info=ALL | grep '^kernel=' | head -1 | cut -d= -f2 || true)"
    if [[ -n "$default_kernel" ]]; then
        grubby --set-default "$default_kernel"
        echo "Standard gesetzt: $default_kernel"
    else
        echo "Kein Kernel gefunden"
    fi
}

install_all() {
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

menu() {
    while true; do
        header
        echo "1) CachyOS Kernel installieren"
        echo "2) Zen Kernel installieren"
        echo "3) Fedora Fallback installieren"
        echo "4) Alle installieren"
        echo "5) GRUB aktualisieren"
        echo "6) Standard Kernel setzen"
        echo "0) Zurück"
        echo
        read -r -p "Auswahl: " choice || return 0
        case "$choice" in
            1) install_cachy ;;
            2) install_zen ;;
            3) install_fedora ;;
            4) install_all ;;
            5) update_grub ;;
            6) set_default_kernel ;;
            0) return 0 ;;
            *) echo "Ungültige Auswahl" ;;
        esac
        read -r -p "Enter drücken..." _ || true
    done
}

check_root
if (($# == 0)); then
    menu
else
    case "$1" in
        cachy) install_cachy ;;
        zen) install_zen ;;
        fedora) install_fedora ;;
        all) install_all ;;
        grub) update_grub ;;
        default) set_default_kernel ;;
        *)
            echo "Benutzung:"
            printf '%s\n' "$0 cachy" "$0 zen" "$0 fedora" "$0 all" "$0 grub" "$0 default"
            exit 2
            ;;
    esac
fi
