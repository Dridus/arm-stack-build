#! /bin/bash

set -x
set -e

./prepare-chroot.sh
chroot /chroot /usr/bin/apt-get update -y
chroot /chroot /usr/bin/apt-get install -y libgmp10
# ( cd /chroot/usr/lib && ln -s libncursesw.so.6 libtinfo.so.5 )
chroot /chroot /usr/bin/apt-get clean
