# archlive

(WIP)

This is my personal Arch Linux distro using `archiso` and based on https://github.com/midfingr/arch_livecd.

## Post install
Restart the system and login to the newly installed Arch Linux OS. Be sure to follow the next instructions to fix some things.
### Reconfigure GRUB
If you are using EFI in a GPT partition and chose GRUB as the default bootloader while dual-booting with Windows, you need to recreate the GRUB config file so that the Windows loader can get recognized properly. You need to execute:
```
# sudo grub-mkconfig -o /boot/grub/grub.cfg
```
### Disabling IPv6
With this basic installation, IPv6 support is enabled by default. So, if you are not using IPv6 support, the boot will take around 25 seconds longer trying to get a lease from the dhcp server, which is quite annoying. As stated in the [wiki](https://wiki.archlinux.org/index.php/IPv6#Disable_IPv6), the best way to fix this is to directly disable the IPv6 support from the kernel line. In other words, you need to edit the file `/etc/default/grub` and append the kernel option `ipv6.disable_ipv6=1` to the `GRUB_CMDLINE_LINUX_DEFAULT` line. It should be something like this:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable_ipv6=1"
```
Also disable the IPv6 support from the `/etc/dhcpcd.conf` file:
```
#Add
noipv6rs
noipv6
```

### Restoring `ping` capabilities and permissions
After installation the `ping` command can only be executed as root, basically [this issue](https://bbs.archlinux.org/viewtopic.php?id=146249). The simplest way to fix this is to install the `iputils` package again:
```
packer -S iputils
```
Then reboot.
