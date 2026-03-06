#!/bin/bash

URL="https://raw.githubusercontent.com/Kaiserrrrrr/aqtive/main/dist"
reboot_now() {  read -p "Reboot now to apply changes? [Y/n] " res; case "$res" in [Yy]*) reboot ;; [Nn]*) echo "Reboot manually to apply changes." && return 0 ;; *) return 0 ;; esac; }

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
