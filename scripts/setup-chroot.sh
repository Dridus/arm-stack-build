#! /bin/bash

./prepare-chroot.sh
chroot /chroot /usr/bin/pacman --noconfirm -Sy
chroot /chroot /usr/bin/pacman --noconfirm -S make gcc ncurses alarm/llvm37
( cd /chroot/usr/lib && ln -s libncursesw.so.6 libtinfo.so.5 )
chroot /chroot bash -c 'cd /root/ghc-8.0.1 && ./configure --prefix=/usr/local && make install'
