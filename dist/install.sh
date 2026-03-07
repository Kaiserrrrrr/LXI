#!/bin/bash

echo "Installing Packages..." && {
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$(cat /sys/class/dmi/id/chassis_type | grep -qE '8|9|10|11|12|14|30|31|32' && echo 1 || echo 0)
DRIVERS="sof-firmware alsa-firmware mesa udisks2 zram-generator"
LXQT="lxqt-session lxqt-panel lxqt-runner lxqt-qtplugin lxqt-globalkeys lxqt-notificationd lxqt-config lxqt-policykit lxqt-powermanagement lxqt-themes pcmanfm-qt qterminal lximage-qt screengrab qps openbox xdg-desktop-portal-lxqt"
UTIL="gnu-free-fonts adobe-source-han-sans-otc-fonts ttf-joypixels breeze-icons gvfs xdg-utils xorg-server lightdm lightdm-gtk-greeter light-locker pipewire-audio pipewire-pulse alsa-utils bluez bluez-utils blueman networkmanager network-manager-applet"

{ [[ "$CPU_VENDOR" =~ "GenuineIntel" ]] && DRIVERS+=" intel-ucode vulkan-intel intel-media-driver thermald" || DRIVERS+=" amd-ucode"; }
{ lspci -n | grep -q "14e4:" && DRIVERS+=" broadcom-wl" || true; }
{ lspci -n | grep -q "10de:" && DRIVERS+=" nvidia nvidia-utils nvidia-settings" || true; }
{ [[ "$IS_LAPTOP" == "1" ]] && DRIVERS+=" xf86-input-libinput tlp" || true; }
{ grep -q "^\[multilib\]" /etc/pacman.conf && DRIVERS+=" lib32-mesa" || true; }

sudo pacman -Syu --noconfirm --needed && sudo pacman -S --noconfirm --needed $DRIVERS $LXQT $UTIL
} >/dev/null 2>&1 && echo "Installation Complete."
