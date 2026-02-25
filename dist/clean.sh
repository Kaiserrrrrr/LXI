#!/bin/bash

sudo find /usr/share/man -type d -name "*_*" -not -name "en*" -exec rm -rf {}
sudo find /usr/share/locale -type d -not -name "en*" -not -name "locale.alias" -delete 

{ sudo pacman -Rns adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-cn-fonts ttf-droid --noconfirm || true; }
{ lscpu 2>/dev/null | grep -iq "Intel" || sudo rm -rf /usr/lib/firmware/intel* }
{ lspci 2>/dev/null | grep -iqE "amd|radeon" || sudo rm -rf /usr/lib/firmware/amdgpu /usr/lib/firmware/radeon }
{ lspci 2>/dev/null | grep -iq "nvidia" || sudo rm -rf /usr/lib/firmware/nvidia }
sudo rm -rf /usr/lib/firmware/{liquidio,qcom,netronome,nfp,mellanox,kaweth,ti-connectivity,mediatek,marvell,cavium,qed}

{ sudo find /usr/lib/modules -name "*.ko" -print0 | xargs -0 -P $(nproc) strip --strip-debug || true; }
{ orphans=$(pacman -Qtdq) && [[ -n "$orphans" ]] && sudo pacman -Rns $orphans --noconfirm || true; }
sudo pacman -Scc --noconfirm 
rm -rf ~/.cache/thumbnails/* ~/.cache/fontconfig/* ~/.local/share/Trash/* 
sudo find /var/log -type f -exec truncate -s 0 {} + && sudo journalctl --vacuum-time=1s
echo -e "\e[32m[✓] Cleanup Complete\e[0m"
