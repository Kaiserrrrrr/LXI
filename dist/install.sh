#!/bin/bash

sudo pacman -Syu --noconfirm --needed >/dev/null 2>&1

CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$([[ -d /sys/class/power_supply/BAT0 || -d /sys/class/input/mouse0 ]] && echo 1 || echo 0)
DRIVERS="sof-firmware alsa-firmware tlp thermald mesa udisks2 zram-generator"

{ [[ "$CPU_VENDOR" =~ "GenuineIntel" ]] && DRIVERS+=" intel-ucode vulkan-intel intel-media-driver" || DRIVERS+=" amd-ucode"; }
{ lspci -n | grep -q "14e4:" && DRIVERS+=" broadcom-wl" || true; }
{ lspci -n | grep -q "10de:" && DRIVERS+=" nvidia nvidia-utils nvidia-settings" || true; }
{ [[ "$IS_LAPTOP" == "1" ]] && DRIVERS+=" xf86-input-libinput" || true; }
{ grep -q "^\[multilib\]" /etc/pacman.conf && DRIVERS+=" lib32-mesa" || true; }

sudo pacman -S --noconfirm --needed $DRIVERS lxqt-session lxqt-panel lxqt-runner lxqt-qtplugin lxqt-globalkeys lxqt-notificationd lxqt-config lxqt-policykit lxqt-powermanagement lxqt-themes pcmanfm-qt qterminal lximage-qt screengrab qps openbox xdg-desktop-portal-lxqt breeze-icons gvfs xdg-utils xorg-server lightdm lightdm-gtk-greeter light-locker pipewire-audio alsa-utils bluez bluez-utils blueman networkmanager network-manager-applet >/dev/null 2>&1

{ [[ ! -f /etc/systemd/zram-generator.conf ]] && echo -e "[zram0]\nzram-size = ram * 0.6\ncompression-algorithm = zstd\nswap-priority = 100\nfs-type = swap" | sudo tee /etc/systemd/zram-generator.conf >/dev/null || true; }
sudo systemctl daemon-reload >/dev/null 2>&1 && sudo usermod -aG video,audio,lp,scanner $USER >/dev/null 2>&1
sudo systemctl enable lightdm bluetooth NetworkManager tlp thermald >/dev/null 2>&1

echo -e "\e[32m[✓] Installation Complete\e[0m"
