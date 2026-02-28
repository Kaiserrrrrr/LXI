#!/bin/bash

URL="https://raw.githubusercontent.com/Kaiserrrrrr/LXI/main/dist"
curl -fsSL "$URL/install.sh" | bash && \
curl -fsSL "$URL/clean.sh" | bash && \

if pgrep -x "lxqt-session" > /dev/null; then
    echo -e "\e[32m[✓] LXI Update Complete.\e[0m" && sync && sleep 3 && clear
else
    echo -e "\e[33m[!] LXI Installation Complete. Rebooting in 5s to apply changes...\e[0m" && sync && sleep 3 && sudo reboot
fi
