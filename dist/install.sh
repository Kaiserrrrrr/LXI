#!/bin/bash

sudo pacman -Syu --noconfirm --needed

USER0="${SUDO_USER: -$USER}"
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$([[ -d /sys/class/power_supply/BAT0 || -d /sys/class/input/mouse0 ]] && echo 1 || echo 0)
DRIVERS="sof-firmware alsa-firmware mesa udisks2 zram-generator"
LXQT="lxqt-session lxqt-panel lxqt-runner lxqt-qtplugin lxqt-globalkeys lxqt-notificationd lxqt-config lxqt-policykit lxqt-powermanagement lxqt-themes pcmanfm-qt qterminal lximage-qt screengrab qps openbox xdg-desktop-portal-lxqt"
UTIL="breeze-icons gvfs xdg-utils xorg-server lightdm lightdm-gtk-greeter light-locker pipewire-audio pipewire-pulse alsa-utils bluez bluez-utils blueman networkmanager network-manager-applet"

{ [[ "$CPU_VENDOR" =~ "GenuineIntel" ]] && DRIVERS+=" intel-ucode vulkan-intel intel-media-driver thermald" || DRIVERS+=" amd-ucode"; }
{ lspci -n | grep -q "14e4:" && DRIVERS+=" broadcom-wl" || true; }
{ lspci -n | grep -q "10de:" && DRIVERS+=" nvidia nvidia-utils nvidia-settings" || true; }
{ [[ "$IS_LAPTOP" == "1" ]] && DRIVERS+=" xf86-input-libinput tlp" || true; }
{ grep -q "^\[multilib\]" /etc/pacman.conf && DRIVERS+=" lib32-mesa" || true; }

sudo pacman -S --noconfirm --needed $DRIVERS $LXQT $UTIL

{ [[ ! -f /etc/systemd/zram-generator.conf ]] && echo -e "[zram0]\nzram-size = ram * 0.6\ncompression-algorithm = zstd\nswap-priority = 100\nfs-type = swap" | sudo tee /etc/systemd/zram-generator.conf || true; }
sudo systemctl daemon-reload && sudo usermod -aG video,audio,lp,scanner "$USER0"
{ [[ "$IS_LAPTOP" == "1" ]] && sudo systemctl enable tlp; }
{ [[ "$IS_LAPTOP" == "1" && "$CPU_VENDOR" =~ "GenuineIntel" ]] && sudo systemctl enable thermald; }
sudo systemctl enable lightdm bluetooth NetworkManager
sudo -u "$USER0" systemctl --user enable --now pipewire pipewire-pulse wireplumber

echo -e "\e[32m[✓] Installation Complete\e[0m"
