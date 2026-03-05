#!/bin/bash

URL="https://raw.githubusercontent.com/Kaiserrrrrr/LXI/main/dist"

if pgrep -x "lxqt-session" > /dev/null; then
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    echo -e "\e[32m[✓] LXI Update Complete.\e[0m" && sync && sleep 3 && clear
else
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/config.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    echo -e "\e[33m[!] LXI Installation Complete. Rebooting in 5s to apply changes...\e[0m" && sync && sleep 3 && sudo reboot
fi
