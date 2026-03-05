#!/bin/bash

reboot_now() { read -p "Reboot Now? [Y/n]: " res; case "$res" in [Yy]*) sudo reboot ;; [Nn]*) exit 0 ;; *) exit 1 ;; esac } 

URL="https://raw.githubusercontent.com/Kaiserrrrrr/aqtive/main/dist"

if pgrep -x "lxqt-session" > /dev/null; then
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    sync && echo -n "[✓] Aqtive Update Complete. " && reboot_now
    
else
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/config.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    sync && echo -n "[✓] Aqtive Installation Complete. " && reboot_now
fi
