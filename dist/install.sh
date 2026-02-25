#!/bin/bash

sudo pacman -Syu --noconfirm --needed 
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$([[ -d /sys/class/power_supply/BAT0 || -d /sys/class/input/mouse0 ]] && echo 1 || echo 0)
DRIVERS="sof-firmware alsa-firmware tlp thermald mesa udisks2 zram-generator"

{ [[ "$CPU_VENDOR" =~ "GenuineIntel" ]] && DRIVERS+=" intel-ucode vulkan-intel intel-media-driver" || DRIVERS+=" amd-ucode"; }
{ lspci -n | grep -q "14e4:" && DRIVERS+=" broadcom-wl" || true; }
{ lspci -n | grep -q "10de:" && DRIVERS+=" nvidia nvidia-utils nvidia-settings" || true; }
{ [[ "$IS_LAPTOP" == "1" ]] && DRIVERS+=" xf86-input-libinput" || true; }
{ grep -q "^\[multilib\]" /etc/pacman.conf && DRIVERS+=" lib32-mesa" || true; }

sudo pacman -S --noconfirm --needed $DRIVERS openbox lxqt-session lxqt-panel lxqt-config lxqt-qtplugin lxqt-powermanagement lxqt-notificationd lxqt-policykit lxqt-globalkeys lxqt-runner lxqt-themes lximage-qt pcmanfm-qt qterminal breeze-icons gvfs light-locker xorg-server lightdm lightdm-gtk-greeter pipewire-audio pavucontrol-qt alsa-utils bluez bluez-utils blueman networkmanager network-manager-applet xdg-utils picom
{ [[ ! -f /etc/systemd/zram-generator.conf ]] && echo -e "[zram0]\nzram-size = ram * 0.6\ncompression-algorithm = zstd\nswap-priority = 100\nfs-type = swap" | sudo tee /etc/systemd/zram-generator.conf || true; }
sudo systemctl daemon-reload && sudo usermod -aG video,audio,lp,scanner $USER 
sudo systemctl enable lightdm bluetooth NetworkManager tlp thermald
echo -e "\e[32m[✓] Installation Complete\e[0m"
