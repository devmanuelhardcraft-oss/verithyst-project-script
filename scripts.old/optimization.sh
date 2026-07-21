#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst System Optimierung"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Bitte mit sudo starten"
    exit 1
fi


echo "[+] Aktiviere Systemdienste..."

systemctl enable fstrim.timer || true


echo "[+] Prüfe Power Profile Konflikt..."

if rpm -q power-profiles-daemon >/dev/null 2>&1; then
    echo "Entferne power-profiles-daemon wegen tuned-ppd Konflikt..."
    dnf remove -y power-profiles-daemon || true
fi


echo "[+] Installiere Optimierungstools..."

dnf install -y \
irqbalance \
tuned \
tuned-ppd \
zram-generator \
--allowerasing


echo "[+] Aktiviere IRQ Balance..."

systemctl enable --now irqbalance || true


echo "[+] Aktiviere Tuned..."

systemctl enable --now tuned || true


echo "[+] Setze Performance Profil..."

tuned-adm profile throughput-performance || true


echo "[+] Aktiviere ZRAM..."

systemctl enable --now systemd-zram-setup@zram0.service || true


echo "[+] Erstelle Kernel Optimierungen..."


cat > /etc/sysctl.d/99-verithyst.conf <<SYSCTL
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_background_ratio=5
vm.dirty_ratio=10
kernel.nmi_watchdog=0
SYSCTL


sysctl --system || true


echo "[+] Begrenze Journal Logs..."

journalctl --vacuum-time=14d || true


echo
echo "================================="
echo " Optimierung abgeschlossen"
echo "================================="

echo
echo "Aktives Profil:"
tuned-adm active || true
