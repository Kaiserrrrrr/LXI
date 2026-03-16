#!/bin/bash

echo -n "Installing Packages... " && {
CPU_VENDOR=$(grep -m1 'vendor_id' /proc/cpuinfo)
IS_LAPTOP=$(cat /sys/class/dmi/id/chassis_type | grep -qE '8|9|10|11|12|14|30|31|32' && echo 1 || echo 0)
DRIVERS="sof-firmware alsa-firmware udisks2"
UTIL="fastfetch htop pipewire-audio pipewire-pulse alsa-utils bluez bluez-utils networkmanager"

{ [[ "$CPU_VENDOR" =~ "GenuineIntel" ]] && DRIVERS+=" intel-ucode vulkan-intel intel-media-driver thermald" || DRIVERS+=" amd-ucode"; }
{ lspci -n | grep -q "14e4:" && DRIVERS+=" broadcom-wl" || true; }
{ lspci -n | grep -q "10de:" && DRIVERS+=" nvidia-open nvidia-utils nvidia-settings" || true; }
{ [[ "$IS_LAPTOP" == "1" ]] && DRIVERS+=" xf86-input-libinput tlp" || true; }
{ grep -q "^\[multilib\]" /etc/pacman.conf && DRIVERS+=" lib32-mesa" || true; }

sudo pacman -Syu --noconfirm --needed && sudo pacman -S --noconfirm --needed $DRIVERS $UTIL
} >/dev/null 2>&1 && echo "Installation Complete."
