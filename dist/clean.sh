#!/bin/bash

sudo find /usr/share/man -type d -name "*_*" -not -name "en*" -exec rm -rf {} + >/dev/null 2>&1
sudo find /usr/share/locale -maxdepth 1 -type d -not -name "en*" -not -name "locale.alias" -not -name "locale" -exec rm -rf {} + >/dev/null 2>&1

{ lscpu | grep -iq "Intel" || sudo rm -rf /usr/lib/firmware/intel*; } >/dev/null 2>&1
{ lspci | grep -iqE "amd|radeon" || sudo rm -rf /usr/lib/firmware/amdgpu /usr/lib/firmware/radeon; } >/dev/null 2>&1
{ lspci | grep -iq "nvidia" || sudo rm -rf /usr/lib/firmware/nvidia; } >/dev/null 2>&1
sudo rm -rf /usr/lib/firmware/{liquidio,qcom,netronome,nfp,mellanox,kaweth,ti-connectivity,mediatek,marvell,cavium,qed} >/dev/null 2>&1

sudo journalctl --vacuum-size=5M >/dev/null 2>&1
sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=5M/' /etc/systemd/journald.conf
sudo sed -i 's/#RuntimeMaxUse=/RuntimeMaxUse=5M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald >/dev/null 2>&1
sudo find /var/log -type f -exec truncate -s 0 {} + >/dev/null 2>&1

sudo find /usr/lib/modules -name "*.ko" -print0 | xargs -0 -r -P $(nproc) strip --strip-debug >/dev/null 2>&1

orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans --noconfirm >/dev/null 2>&1
fi

sudo pacman -Scc --noconfirm >/dev/null 2>&1
rm -rf ~/.cache/thumbnails/* ~/.cache/fontconfig/* ~/.local/share/Trash/*
echo -e "\e[32m[✓] Cleanup Complete\e[0m"
