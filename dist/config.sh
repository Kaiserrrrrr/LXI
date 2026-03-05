CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$(cat /sys/class/dmi/id/chassis_type | grep -qE '8|9|10|11|12|14|30|31|32' && echo 1 || echo 0)

{ [[ ! -f /etc/systemd/zram-generator.conf ]] && echo -e "[zram0]\nzram-size = ram * 0.6\ncompression-algorithm = zstd\nswap-priority = 100\nfs-type = swap" | sudo tee /etc/systemd/zram-generator.conf || true; }
sudo systemctl daemon-reload && sudo usermod -aG video,audio,lp,scanner "$USER"
{ [[ "$IS_LAPTOP" == "1" ]] && sudo systemctl enable tlp; }
{ [[ "$IS_LAPTOP" == "1" && "$CPU_VENDOR" =~ "GenuineIntel" ]] && sudo systemctl enable thermald; }
sudo systemctl enable lightdm bluetooth NetworkManager
sudo -u "$USER" systemctl --user enable --now pipewire pipewire-pulse wireplumber

echo -e "\e[32m[✓] Configuration Complete\e[0m"
