#!/bin/bash

export MAKEFLAGS="-j$(nproc)" && { [[ -d /sys/devices/system/cpu/cpu0/cpufreq ]] && echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor || true; }

URL="https://raw.githubusercontent.com/Kaiserrrrrr/LXI/main/dist"
curl -fsSL "$URL/install.sh" | bash && \
curl -fsSL "$URL/clean.sh" | bash && \

{ [[ -d /sys/devices/system/cpu/cpu0/cpufreq ]] && echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor || true; } 

if pgrep -x "lxqt-session" > /dev/null; then
    echo -e "\e[32m[✓] LXI Installation Complete.\e[0m" && sync && sleep 3 && clear
else
    echo -e "\e[33m[!] LXI Installation Complete. Rebooting in 5s to apply changes...\e[0m" && sync && sleep 3 && sudo reboot
fi
