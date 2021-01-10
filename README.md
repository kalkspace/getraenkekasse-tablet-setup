# KalkSpace Mete Tablet Setup

We are using a Dell Venue tablet to manage the drinks in our space. The tablet runs [mete](https://github.com/chaosdorf/mete)

This thing is quite difficult to setup/operate (but also many many bonus points for hackiness, geekiness :D):

1. Low memory

It only has 1GB of RAM making it challenging to run a browser + mete on it.

2. 32Bit EFI

The device has a 64Bit processor but only has a 32bit EFI system. This requires a special installation medium

## Preparation

Generate a USB stick following the instructions in the debian-iso subdir

## Debian installation

**_INCOMPLETE_**

Please ignore wifi errors during install and just "continue without configuring a network at this time".
Unknown what is going on in the installer.

During installation create the user `mete-mgmt`.

grub-ia32 for some reason doesn't properly install :|
Reboot to stick after installation

Press C to enter GRUB command line

```
linux (hd1,gpt2)/vmlinuz root=/dev/mmcblk1p2
initrd (hd1,gpt2)/initrd.img
boot
```

```
mount /dev/sda1 /media/cdrom
apt-get install wpasupplicant sudo openssh-server
grub-install --bootloader-id=debian
systemctl enable ssh
systemctl start ssh
# add mete-mgmt to sudo group
# update sources.list to official http sources
```

https://wiki.debian.org/WiFi/HowToUse#wpa_supplicant

## Install kiosk
