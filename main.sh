#!/bin/bash

{ [ "$(id -u)" -ne 0 ] && echo "Error: This script must be run as root." >&2 && exit 1; } 
reboot_now() {  read -p "Reboot now to apply changes? [Y/n] " res < /dev/tty; case "$res" in [Yy]*) reboot ;; [Nn]*) return 0 ;; *) return 0 ;; esac; }

URL="https://raw.githubusercontent.com/Kaiserrrrrr/aqtive/main/dist"

if pgrep -x "lxqt-session" > /dev/null; then
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    sync && echo -n "Aqtive Update Complete. " && reboot_now
else
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/config.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    sync && echo -n "Aqtive Installation Complete. " && reboot_now
fi
