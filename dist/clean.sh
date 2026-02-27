#!/bin/bash

sudo journalctl --vacuum-size=5M >/dev/null 2>&1
sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=5M/' /etc/systemd/journald.conf
sudo sed -i 's/#RuntimeMaxUse=/RuntimeMaxUse=5M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald >/dev/null 2>&1
sudo find /var/log -type f -exec truncate -s 0 {} + >/dev/null 2>&1

orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans --noconfirm >/dev/null 2>&1
fi

hw_data=$(lspci -k; lsusb)

if [[ -n "$hw_data" ]]; then
        for pkg in $(pacman -Qqs linux-firmware-); do
        
        vendor=${pkg#linux-firmware-}
        
        if [[ "$vendor" == "whence" || "$vendor" == "other" ]]; then
            continue
        fi
        
        if ! echo "$hw_data" | grep -wiq "$vendor"; then
            sudo pacman -Rdd --noconfirm "$pkg" >/dev/null 2>&1
        fi
    done
fi

sudo pacman -Scc --noconfirm >/dev/null 2>&1
rm -rf ~/.cache/thumbnails/* ~/.cache/fontconfig/* ~/.local/share/Trash/*
echo -e "\e[32m[✓] Cleanup Complete\e[0m"
