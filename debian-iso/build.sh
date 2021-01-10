#!/bin/sh

set -e

usage()
{
cat << EOF
usage: $(basename $0) [iso] [usbdev]

iso: must be the path to a debian netinst bullseye iso.
Example: "~/debian-bullseye-DI-alpha3-amd64-netinst.iso"

usbdev: must be the path to a usb blockdevice
Example: "/dev/sda"

WARNING. After confirmation this script will destroy any contents
on the stick

-y  Don't ask for confirmation
EOF
}


ISO=$1
USBDEV=$2

if [ -z "$ISO" ]; then
    usage
    exit 1
fi

if [ -z "$USBDEV" ]; then
    usage
    exit 2
fi

shift
shift

optstring=":y"

YES=""

while getopts ${optstring} arg; do
  case ${arg} in
    y)
      YES="1"
      ;;
    :)
      echo "$0: Must supply an argument to -$OPTARG." >&2
      exit 3 
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 4
      ;;
  esac
done

if [ -z "$YES" ]; then
    echo "This will prepare a USB Stick at device $USBDEV (should be something like /dev/sda) from the isofile $ISO."
    echo "This will repartition and fully wipe $USBDEV"
    echo "You likely have to execute this script as root"
    echo "Enter 'yes' to confirm. Anything else will abort"
    read CONFIRM

    if [ "$CONFIRM" != "yes" ]; then
        echo "Aborting"
        exit 5
    fi
fi

cleanup()
{
    echo "cleaning up"
    set +e
    sync ${USBDEV}1
    sync ${USBDEV}2
    umount /tmp/debian-bullseye-kalkspace-iso/iso-{data,efi}
    losetup -D
    umount /tmp/debian-bullseye-kalkspace-iso/stick-{data,efi}
    rm -r /tmp/debian-bullseye-kalkspace-iso
}

trap cleanup EXIT

BLOCKDEV=$(basename $USBDEV)

sfdisk --delete -X gpt $USBDEV
sfdisk $USBDEV << EOF
,4GB,U
,500MB,U
EOF

# mount source and target dirs
mkdir -p /tmp/debian-bullseye-kalkspace-iso/iso-{data,efi}
mkdir -p /tmp/debian-bullseye-kalkspace-iso/stick-{data,efi}
LOOP=$(losetup --find --show --partscan --read-only $ISO)
mount ${LOOP}p1 /tmp/debian-bullseye-kalkspace-iso/iso-data
cp -a /tmp/debian-bullseye-kalkspace-iso/iso-data /tmp/debian-bullseye-kalkspace-iso/iso-data-modified
mount ${USBDEV}1 /tmp/debian-bullseye-kalkspace-iso/stick-data

# add grub-ia32 to installation medium
GRUB=$(zcat /home/mop/Downloads/Packages.gz | rg -U "Package: grub-efi-ia32\n(^[^\n]+\n)*" | rg "^Filename" | sed -e 's/Filename: //g')
GRUB_BIN=$(zcat /home/mop/Downloads/Packages.gz | rg -U "Package: grub-efi-ia32-bin\n(^[^\n]+\n)*" | rg "^Filename" | sed -e 's/Filename: //g')
mkdir -p /tmp/debian-bullseye-kalkspace-iso/iso-data-modified/$(dirname $GRUB)
mkdir -p /tmp/debian-bullseye-kalkspace-iso/iso-data-modified/$(dirname $GRUB_BIN)
(cd /tmp/debian-bullseye-kalkspace-iso/iso-data-modified/$(dirname $GRUB) && wget http://ftp.us.debian.org/debian/$GRUB)
(cd /tmp/debian-bullseye-kalkspace-iso/iso-data-modified/$(dirname $GRUB_BIN) && wget http://ftp.us.debian.org/debian/$GRUB_BIN)

# regenerate Release, Packages and what not
docker run --rm -v /tmp/debian-bullseye-kalkspace-iso/iso-data-modified/:/data -v $(pwd)/regenerate-debian-stuff.sh:/regenerate-debian-stuff.sh debian /regenerate-debian-stuff.sh
(cd /tmp/debian-bullseye-kalkspace-iso/iso-data-modified/ && md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt)

# finally create the installation medium
# debian installer requires either vfat (symlinks which are present in the installer medium)
xorriso -as mkisofs -o /tmp/debian-bullseye-kalkspace-iso/installer.iso /tmp/debian-bullseye-kalkspace-iso/iso-data-modified
dd if=/tmp/debian-bullseye-kalkspace-iso/installer.iso of=${USBDEV}1 bs=4M conv=fsync
yes | mkfs.fat -F32 ${USBDEV}2
mount ${LOOP}p2 /tmp/debian-bullseye-kalkspace-iso/iso-efi
mount ${USBDEV}2 /tmp/debian-bullseye-kalkspace-iso/stick-efi
mkdir -p /tmp/debian-bullseye-kalkspace-iso/stick-efi/EFI/boot

# install grub on second partition
grub-mkstandalone -d /usr/lib/grub/i386-efi -O i386-efi --modules="part_gpt part_msdos ext2 video" --locales="en@quot" --themes="" -o "/tmp/debian-bullseye-kalkspace-iso/stick-efi/EFI/boot/bootia32.efi" "boot/grub/grub.cfg=./grub.cfg" -v
