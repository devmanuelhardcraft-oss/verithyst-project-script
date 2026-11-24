#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten" >&2
    exit 1
fi
if ! command -v dnf >/dev/null 2>&1; then
    echo "[FEHLER] DNF wurde nicht gefunden." >&2
    exit 1
fi

echo "================================="
echo " Verthyst System-Optimierung"
echo "================================="
echo "Die Optimierung installiert Diagnose-/Wartungstools und aktiviert TRIM."
echo "Bestehende Energieprofile und Kernel-Parameter werden nicht überschrieben."
read -r -p "Fortfahren? [j/N] " answer
[[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || { echo "Abgebrochen."; exit 0; }

echo "[+] Installiere unterstützende Werkzeuge..."
dnf install -y irqbalance tuned

echo "[+] Aktiviere periodisches SSD-TRIM..."
systemctl enable --now fstrim.timer

echo "[+] Aktiviere IRQ-Balance (falls vom System unterstützt)..."
systemctl enable --now irqbalance.service || echo "[INFO] irqbalance konnte auf diesem System nicht aktiviert werden."

echo
echo "Aktuelles Energieprofil:"
if command -v powerprofilesctl >/dev/null 2>&1; then
    powerprofilesctl get || true
fi
if command -v tuned-adm >/dev/null 2>&1; then
    tuned-adm active || true
fi

echo
echo "[OK] Basis-Optimierung abgeschlossen."
echo "Hinweis: Ein Performance-Profil sollte passend zu Hardware und Nutzung manuell gewählt werden."
