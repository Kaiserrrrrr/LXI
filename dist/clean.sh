#!/bin/bash

{
sudo journalctl --vacuum-size=5M 
sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=5M/' /etc/systemd/journald.conf
sudo sed -i 's/#RuntimeMaxUse=/RuntimeMaxUse=5M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald 
find /var/log -type f -exec truncate -s 0 {} +
rm -rf ~/.cache/thumbnails/* ~/.cache/fontconfig/* ~/.local/share/Trash/*

hw_data=$(lspci -k; lsusb)
pacman -Qqs linux-firmware- | grep -vE 'whence|other' | while read -r pkg; do
    vendor=${pkg#linux-firmware-}
    echo "$hw_data" | grep -wiq "$vendor" || sudo pacman -Rdd --noconfirm "$pkg"
done

pacman -Qtdq | xargs -r sudo pacman -Rns --noconfirm && sudo pacman -Scc --noconfirm 
} >/dev/null 2>&1 && echo "Cleanup Complete."
