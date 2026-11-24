#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten." >&2
    exit 1
fi
command -v dnf >/dev/null 2>&1 || { echo "[FEHLER] DNF nicht gefunden." >&2; exit 1; }

echo "================================="
echo " Verthyst: System Update"
echo "================================="
echo "Ein System-Upgrade kann einen Neustart erforderlich machen."
read -r -p "Updates jetzt installieren? [j/N] " answer
[[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]] || { echo "Abgebrochen."; exit 0; }

echo "[+] Aktualisiere Paketdaten..."
dnf makecache --refresh
echo "[+] Installiere Systemupdates..."
dnf upgrade --refresh -y

if command -v fwupdmgr >/dev/null 2>&1; then
    echo "[+] Suche Firmware-Updates..."
    fwupdmgr refresh --force || echo "[WARN] Firmware-Metadaten konnten nicht aktualisiert werden."
    fwupdmgr get-updates || true
    echo "[INFO] Firmware-Updates werden nicht automatisch installiert. Bitte Ausgabe prüfen."
else
    echo "[INFO] fwupdmgr ist nicht installiert."
fi

echo "[OK] System aktualisiert. Prüfe bei Bedarf mit 'needs-restarting -r', ob ein Neustart nötig ist."
