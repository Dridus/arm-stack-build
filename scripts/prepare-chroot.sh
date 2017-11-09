#! /bin/bash

set -e
set -x

rm -f /chroot/etc/resolv.conf
cp /etc/resolv.conf /chroot/etc/resolv.conf
cp /usr/bin/qemu-arm-static /chroot/usr/bin

update-binfmts --enable
mount --bind /chroot /chroot
if [ -d /.stack ]; then
  mkdir -p /chroot/root/.stack
  mount --rbind /.stack /chroot/root/.stack
fi
if [ -d /project ]; then
  mkdir -p /chroot/project
  mount --rbind /project /chroot/project
fi
mkdir -p /chroot/{proc,dev,run,sys}
mount -t proc proc /chroot/proc
mount --rbind /dev /chroot/dev
mount --rbind /run /chroot/run
mount --rbind /sys /chroot/sys
