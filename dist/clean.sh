#!/bin/bash

sudo find /usr/share/man -type d -name "*_*" -not -name "en*" -exec rm -rf {} + 2>/dev/null
sudo find /usr/share/locale -type d -not -name "en*" -not -name "locale.alias" -delete 2>/dev/null

{ sudo pacman -Rns adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-cn-fonts ttf-droid --noconfirm >/dev/null 2>&1 || true; }
{ lscpu 2>/dev/null | grep -iq "Intel" || sudo rm -rf /usr/lib/firmware/intel* 2>/dev/null; }
{ lspci 2>/dev/null | grep -iqE "amd|radeon" || sudo rm -rf /usr/lib/firmware/amdgpu /usr/lib/firmware/radeon 2>/dev/null; }
{ lspci 2>/dev/null | grep -iq "nvidia" || sudo rm -rf /usr/lib/firmware/nvidia 2>/dev/null; }
sudo rm -rf /usr/lib/firmware/{liquidio,qcom,netronome,nfp,mellanox,kaweth,ti-connectivity,mediatek,marvell,cavium,qed} 2>/dev/null

{ sudo find /usr/lib/modules -name "*.ko" -print0 2>/dev/null | xargs -0 -P $(nproc) strip --strip-debug 2>/dev/null || true; }
{ orphans=$(pacman -Qtdq) && [[ -n "$orphans" ]] && sudo pacman -Rns $orphans --noconfirm >/dev/null 2>&1 || true; }
sudo pacman -Scc --noconfirm >/dev/null 2>&1
rm -rf ~/.cache/thumbnails/* ~/.cache/fontconfig/* ~/.local/share/Trash/* 2>/dev/null
sudo find /var/log -type f -exec truncate -s 0 {} + && sudo journalctl --vacuum-time=1s >/dev/null 2>&1
echo -e "\e[32m[✓] Cleanup Complete\e[0m"
