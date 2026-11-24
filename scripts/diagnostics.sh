#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$(dirname -- "$SCRIPT_DIR")/environment.sh"

section() { printf '\n===== %s =====\n' "$1"; }

section "Verthyst"
printf 'Projektpfad: %s\n' "$VERTHYST_ROOT"
printf 'Benutzer:    %s\n' "$VERTHYST_USER"
printf 'Home:        %s\n' "$VERTHYST_HOME"

section "System"
cat /etc/os-release 2>/dev/null | grep -E '^(PRETTY_NAME|VERSION_ID)=' || true
printf 'Kernel:      %s\n' "$(uname -r)"
printf 'Architektur: %s\n' "$(uname -m)"

section "Speicherplatz"
df -h / /home 2>/dev/null || df -h /

section "Hardware"
if command -v lscpu >/dev/null 2>&1; then lscpu | grep -E '^(Model name|CPU\(s\)):' || true; fi
if command -v lspci >/dev/null 2>&1; then
    lspci | grep -Ei 'VGA|3D controller|Display controller|Network controller' || true
fi

section "Wichtige Werkzeuge"
for tool in dnf flatpak git curl dialog lspci; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf '[OK] %s: %s\n' "$tool" "$(command -v "$tool")"
    else
        printf '[--] %s nicht installiert\n' "$tool"
    fi
done

section "Projektmodule"
for module in environment.sh install.sh gui/main.sh scripts/repos.sh scripts/packages.sh scripts/gaming.sh scripts/optimization.sh scripts/update.sh scripts/cleanup.sh kernels/kernel.sh flatpaks/flatpak.sh drivers/driver.sh; do
    if [[ -f "$VERTHYST_ROOT/$module" ]]; then
        printf '[OK] %s\n' "$module"
    else
        printf '[FEHLT] %s\n' "$module"
    fi
done

echo
echo "Diagnose abgeschlossen. Es wurden keine Systemeinstellungen verändert."
