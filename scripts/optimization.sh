#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst System Optimierung"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Bitte mit sudo starten"
    exit 1
fi


echo "[+] Aktiviere Dienste..."

systemctl enable fstrim.timer || true


echo "[+] Entferne Power Profile Konflikt..."

dnf remove -y power-profiles-daemon || true


echo "[+] Installiere Optimierungstools..."

dnf install -y \
irqbalance \
tuned \
tuned-ppd \
zram-generator


echo "[+] Aktiviere IRQ Balance..."

systemctl enable --now irqbalance || true


echo "[+] Aktiviere Tuned..."

systemctl enable --now tuned


echo "[+] Setze Gaming Performance Profil..."

tuned-adm profile throughput-performance || true


echo "[+] Aktiviere ZRAM..."

systemctl enable --now systemd-zram-setup@zram0.service || true


echo "[+] Erstelle Verithyst Kernel Optimierungen..."

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
tuned-adm active || true#!/usr/bin/env bash

set -e

echo "================================="
echo " Verithyst System Optimierung"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Bitte mit sudo starten"
    exit 1
fi


echo "[+] Aktiviere Dienste..."

systemctl enable fstrim.timer || true


echo "[+] Entferne Power Profile Konflikt..."

dnf remove -y power-profiles-daemon || true


echo "[+] Installiere Optimierungstools..."

dnf install -y \
irqbalance \
tuned \
tuned-ppd \
zram-generator


echo "[+] Aktiviere IRQ Balance..."

systemctl enable --now irqbalance || true


echo "[+] Aktiviere Tuned..."

systemctl enable --now tuned


echo "[+] Setze Gaming Performance Profil..."

tuned-adm profile throughput-performance || true


echo "[+] Aktiviere ZRAM..."

systemctl enable --now systemd-zram-setup@zram0.service || true


echo "[+] Erstelle Verithyst Kernel Optimierungen..."

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
