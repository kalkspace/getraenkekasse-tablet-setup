# Description

this creates a bootable amd64 debian bullseye usb stick that boots from an ia32 EFI.

If you need special firmware make sure to download an appropriate image

(e.g. something like https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/bullseye_di_alpha3+nonfree/amd64/iso-cd/)

The kalkspace tablet does NOT need special firmware to work as intended (wifi etc. will not work but they are not in use)
so the standard installation medium is enough.

## Prerequisites

A linux system with `docker`, `sfdisk`, `xorriso`, `rg`, `wget` and everything needed for a `grub` ia32 installation.

## Building

`sudo ./build.sh /home/mop/Downloads/firmware-testing-amd64-netinst.iso /dev/sda`

## Caveats

The build process fetches the most recent grub-efi-ia32. It might happen that
this version has other dependencies (e.g. requires newer grub-common) than
what is present on the original ISO.

Unfortunately this problem will pop up during the FINAL step of installation and
will leave you without a bootloader :(

Please make sure you have a recent installation medium (for example download daily build)
to prevent that from happening.

So far this is unsolved.

It is manually fixable using grub rescue from iso though.
