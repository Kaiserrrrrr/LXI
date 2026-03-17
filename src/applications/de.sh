#!/bin/bash

while true; do
    echo "--- Select a Desktop Environment ---"
    echo "1) Budgie        2) Cinnamon      3) COSMIC        4) Cutefish"
    echo "5) Deepin        6) Enlightenment 7) GNOME         8) KDE Plasma"
    echo "9) LXDE         10) LXQt         11) MATE         12) Sugar"
    echo "13) Xfce"
    echo "-------------------------------------"
    
    read -p "Enter selection (1-13): " CHOICE < /dev/tty

    case $CHOICE in
        1)  DE="budgie"; break ;;
        2)  DE="cinnamon"; break ;;
        3)  DE="cosmic"; break ;;
        4)  DE="cutefish"; break ;;
        5)  DE="deepin"; break ;;
        6)  DE="enlightenment"; break ;;
        7)  DE="gnome"; break ;;
        8)  DE="plasma"; break ;;
        9)  DE="lxde"; break ;;
        10) DE="lxqt"; break ;;
        11) DE="mate"; break ;;
        12) DE="sugar"; break ;;
        13) DE="xfce"; break ;;
        *)  clear
            echo "Error: '$CHOICE' is not a valid option. Please try again."
            echo "" ;;
    esac
done

PKG=$(curl -s "https://raw.githubusercontent.com/kaiserrrrrr/aqtive/main/src/de/$DE")

if [ -n "$PKG" ]; then
     echo -e -n "\n\nInstallating $DE... " && { sudo pacman -Syu --noconfirm && sudo pacman -S $PKG --noconfirm && sudo pacman -Scc --noconfirm } >/dev/null 2>&1
else
     echo "Error: Could not retrieve packages for $DE."
fi

if echo "$PKG" | grep -q "gdm"; then
    sudo systemctl enable gdm
elif echo "$PKG" | grep -q "sddm"; then
    sudo systemctl enable sddm
elif echo "$PKG" | grep -q "lightdm"; then
    sudo systemctl enable lightdm
elif echo "$PKG" | grep -q "greetd"; then
    sudo systemctl enable greetingd
fi


sync && echo "$DE Installation Complete... " && {  read -p "reboot now to apply changes? [Y/n] " res < /dev/tty; case "$res" in [Yy]*) sudo reboot ;; [Nn]*) clear && return 0 ;; *) clear && return 0 ;; esac; }
