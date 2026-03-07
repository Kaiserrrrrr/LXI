#!/bin/bash

echo "Configuring Machine..." && {
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$(cat /sys/class/dmi/id/chassis_type | grep -qE '8|9|10|11|12|14|30|31|32' && echo 1 || echo 0)
ACTIVE_SESSION=$(loginctl show-seat seat0 -p ActiveSession --value)
USER0=$(loginctl show-session "$ACTIVE_SESSION" -p Name --value)
UID0=$(id -u "$USER0")

{ [[ ! -f /etc/systemd/zram-generator.conf ]] && echo -e "[zram0]\nzram-size = ram * 0.6\ncompression-algorithm = zstd\nswap-priority = 100\nfs-type = swap" | sudo tee /etc/systemd/zram-generator.conf || true; }
{ sudo systemctl daemon-reload && sudo usermod -aG video,audio,lp,scanner "$USER0"; }
{ sudo systemctl enable lightdm bluetooth NetworkManager; }
{ [[ "$IS_LAPTOP" == "1" ]] && sudo systemctl enable tlp; }
{ [[ "$IS_LAPTOP" == "1" && "$CPU_VENDOR" =~ "GenuineIntel" ]] && sudo systemctl enable thermald; }
{ sudo -u "$USER0" XDG_RUNTIME_DIR="/run/user/$UID0" systemctl --user enable --now pipewire pipewire-pulse wireplumber; } 
} >/dev/null 2>&1 && echo "Configuration Complete."
