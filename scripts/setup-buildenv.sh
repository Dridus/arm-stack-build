#! /bin/bash

set -x
set -e

./prepare-chroot.sh
chroot /chroot /usr/bin/apt-get update -y
chroot /chroot /usr/bin/apt-get install -y make binutils libgmp10-dev libncurses5 libncurses5-dev ca-certificates xz-utils
chroot /chroot bash -c 'stack setup --resolver lts-8.24 --install-ghc'
