#!/bin/bash

# Aqtive v1.0.0
# =============
# LXQt on Arch made effortless
# Project: https://github.com/kaiserrrrrr/aqtive

sudo -v; clear && echo '

 /$$           /$$$$$$   /$$$$$$  /$$$$$$$$ /$$$$$$ /$$    /$$ /$$$$$$$$
|  $$         /$$__  $$ /$$__  $$|__  $$__/|_  $$_/| $$   | $$| $$_____/
 \  $$       | $$  \ $$| $$  \ $$   | $$     | $$  | $$   | $$| $$      
  \  $$      | $$$$$$$$| $$  | $$   | $$     | $$  |  $$ / $$/| $$$$$   
   /$$/      | $$__  $$| $$  | $$   | $$     | $$   \  $$ $$/ | $$__/   
  /$$/       | $$  | $$| $$/$$ $$   | $$     | $$    \  $$$/  | $$      
 /$$/        | $$  | $$|  $$$$$$/   | $$    /$$$$$$   \  $/   | $$$$$$$$
|__/         |__/  |__/ \____ $$$   |__/   |______/    \_/    |________/
                             \__/                                       

' | cat

URL="https://raw.githubusercontent.com/kaiserrrrrr/aqtive/main/src/"

reboot_now() {  read -p "Reboot now to apply changes? [Y/n] " res < /dev/tty; case "$res" in [Yy]*) reboot ;; [Nn]*) clear && return 0 ;; *) clear && return 0 ;; esac; }
de_install() {  read -p "Install Desktop Environment? [Y/n] " res < /dev/tty; case "$res" in [Yy]*) curl -fsSL "$URL/de/main.sh" | sh ;; [Nn]*) reboot_now ;; *) clear && return 0 ;; esac; }

if [[ "$XDG_SESSION_TYPE" == "x11" || "$XDG_SESSION_TYPE" == "wayland" || -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
    curl -fsSL "$URL/applications/install.sh" | sh && \
    curl -fsSL "$URL/applications/clean.sh" | sh && \
    sync && echo -n "Update Complete. " && reboot_now
else
    curl -fsSL "$URL/applications/install.sh" | sh && \
    curl -fsSL "$URL/applications/config.sh" | sh && \
    curl -fsSL "$URL/applications/clean.sh" | sh && \
    sync && echo -n "Installation Complete. " && de_install
fi
