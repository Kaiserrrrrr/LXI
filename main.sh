#!/bin/bash

sudo -v; URL="https://raw.githubusercontent.com/Kaiserrrrrr/aqtive/main/dist"
reboot_now() {  read -p "Reboot now to apply changes? [Y/n] " res < /dev/tty; case "$res" in [Yy]*) reboot ;; [Nn]*) return 0 ;; *) return 0 ;; esac; }

echo '

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

if pgrep -x "lxqt-session" > /dev/null; then
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    sync && echo -n "Update Complete. " && reboot_now
else
    curl -fsSL "$URL/install.sh" | sh && \
    curl -fsSL "$URL/config.sh" | sh && \
    curl -fsSL "$URL/clean.sh" | sh && \
    sync && echo -n "Installation Complete. " && reboot_now
fi
