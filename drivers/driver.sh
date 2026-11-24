#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Bitte mit sudo starten." >&2
    exit 1
fi
command -v dnf >/dev/null 2>&1 || { echo "[FEHLER] DNF nicht gefunden." >&2; exit 1; }

echo "================================="
echo " Verthyst: Grafiktreiber-Check"
echo "================================="

if command -v lspci >/dev/null 2>&1; then
    GPU_INFO="$(lspci -nn | grep -Ei 'VGA compatible controller|3D controller|Display controller' || true)"
else
    GPU_INFO="lspci ist nicht installiert; Hardware-Erkennung nicht möglich."
fi
printf '%s\n' "$GPU_INFO"
echo

if grep -qi 'NVIDIA' <<<"$GPU_INFO"; then
    echo "[INFO] NVIDIA-Grafik erkannt."
    if rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
        echo "RPM Fusion Nonfree ist installiert."
        read -r -p "NVIDIA-Treiber (akmod-nvidia) installieren? [j/N] " answer
        if [[ "$answer" =~ ^([jJ]|[jJ][aA])$ ]]; then
            dnf install -y akmod-nvidia
            echo "[INFO] Kernelmodul-Build kann einige Minuten dauern. Vor dem Neustart den Build abwarten."
        fi
    else
        echo "[WARN] RPM Fusion Nonfree fehlt. Starte zuerst den Repository-Schritt."
    fi
elif grep -Eqi 'AMD|ATI|Advanced Micro Devices' <<<"$GPU_INFO"; then
    echo "[INFO] AMD-Grafik erkannt. Fedora verwendet normalerweise den integrierten Mesa/amdgpu-Treiber."
    echo "Keine proprietäre Treiberinstallation wird automatisch vorgenommen."
elif grep -qi 'Intel' <<<"$GPU_INFO"; then
    echo "[INFO] Intel-Grafik erkannt. Fedora verwendet normalerweise den integrierten i915/xe- und Mesa-Treiber."
    echo "Keine proprietäre Treiberinstallation wird automatisch vorgenommen."
else
    echo "[INFO] Kein unterstützter GPU-Hersteller eindeutig erkannt."
fi

echo
echo "Aktiver Grafiktreiber:"
if command -v lspci >/dev/null 2>&1; then
    lspci -k | grep -A3 -Ei 'VGA compatible controller|3D controller|Display controller' || true
fi
