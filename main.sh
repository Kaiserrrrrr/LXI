#!/bin/bash

export MAKEFLAGS="-j$(nproc)" && { [[ -d /sys/devices/system/cpu/cpu0/cpufreq ]] && echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor || true; }

URL="https://raw.githubusercontent.com/Kaiserrrrrr/LXI/main/dist"
curl -fsSL "$URL/install.sh" | bash && \
curl -fsSL "$URL/clean.sh" | bash && \

{ [[ -d /sys/devices/system/cpu/cpu0/cpufreq ]] && echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor || true; } && sync
