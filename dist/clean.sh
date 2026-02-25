#!/bin/bash

sudo find /usr/share/man -type d -name "*_*" -not -name "en*" -exec rm -rf {} +
sudo find /usr/share/locale -maxdepth 1 -type d -not -name "en*" -not -name "locale.alias" -not -name "locale" -exec rm -rf {} +

{ lscpu | grep -iq "Intel" || sudo rm -rf /usr/lib/firmware/intel*; }
{ lspci | grep -iqE "amd|radeon" || sudo rm -rf /usr/lib/firmware/amdgpu /usr/lib/firmware/radeon; }
{ lspci | grep -iq "nvidia" || sudo rm -rf /usr/lib/firmware/nvidia; }
sudo rm -rf /usr/lib/firmware/{liquidio,qcom,netronome,nfp,mellanox,kaweth,ti-connectivity,mediatek,marvell,cavium,qed}

sudo journalctl --vacuum-size=5M
sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=5M/' /etc/systemd/journald.conf
sudo sed -i 's/#RuntimeMaxUse=/RuntimeMaxUse=5M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
sudo find /var/log -type f -exec truncate -s 0 {} +

{ sudo find /usr/lib/modules -name "*.ko" -print0 | xargs -0 -P $(nproc) strip --strip-debug || true; }

orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans --noconfirm
fi

sudo pacman -Scc --noconfirm 
rm -rf ~/.cache/thumbnails/* ~/.cache/fontconfig/* ~/.local/share/Trash/* echo -e "\e[32m[✓] Cleanup Complete\e[0m"
