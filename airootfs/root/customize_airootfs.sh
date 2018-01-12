#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/archlinux/wallpaper/archlinux-deep-aurora.jpg'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/archlinux/wallpaper/archlinux-aftermath.jpg'
gsettings set org.gnome.desktop.interface cursor-theme Breeze
gsettings set org.gnome.desktop.interface gtk-theme Adapta
gsettings set org.gnome.desktop.interface icon-theme Papirus
gsettings set org.gnome.desktop.background show-desktop-icons true
gsettings set org.gnome.nautilus.preferences always-use-location-entry true

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default graphical.target
