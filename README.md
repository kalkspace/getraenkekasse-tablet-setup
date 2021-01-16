# KalkSpace Mete Tablet Setup

We are using a Dell Venue tablet to manage the drinks in our space. The tablet runs [mete](https://github.com/chaosdorf/mete)

This thing is quite difficult to setup/operate (but also many many bonus points for hackiness, geekiness :D):

1. Low memory

It only has ~~1GB~~ THE NEW HAS 2GB of RAM making it challenging to run a browser + mete on it.

2. 32Bit EFI

The device has a 64Bit processor but only has a 32bit EFI system. This requires a special installation medium

3. Linux desktop

- on screen keyboard required
- gnome is looking quite good (has OSK etc.) but needs stronger hardware and more mem
- camera support? => might need custom kernel https://www.kernelconfig.io/config_intel_atomisp

## Preparation

Generate a USB stick following the instructions in the debian-iso subdir

## Debian installation

Start the tablet and hold volume down to enter the BIOS.
Verify "Secure Boot/Secure Boot Enable" is off
Verify "System Configuration/USB Configuration/(Enable Boot Support and External Usb)" is on

Go to "General/Boot Sequence" and add a "stick" "Boot option" using the EFI Image from the stick.

Do a standard install (use entire disk etc.).

During installation create the user `mete-mgmt`.

The installer fails to properly install the grub bootloader into EFI unfortunately.

Restart into BIOS once more.

Go to "General/Boot Sequence".

Select "Add boot option" and select "\EFI\debian\grubia32.efi" from the MMC filesystem.

## Install kiosk

For ansible to work you first need to manually install `sudo` and add `mete-mgmt`
to the `sudo` group in /etc/group.

`ansible-playbook tablet.yml -v -i inventory.ini --ask-pass -K`
