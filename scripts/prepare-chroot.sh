#! /bin/bash

set -x
rm -f /chroot/etc/resolv.conf
cp /etc/resolv.conf /chroot/etc/resolv.conf
cp /usr/bin/qemu-arm-static /chroot/usr/bin
update-binfmts --enable
mount --bind /chroot /chroot
mount -t proc proc /chroot/proc
mount --rbind /dev /chroot/dev
mount --rbind /run /chroot/run
mount --rbind /sys /chroot/sys