FROM ubuntu:latest
MAINTAINER rmm-github@z.odi.ac
COPY dists/arch.tar.gz dists/ghc.tar.xz dists/stack.tar.gz /
RUN apt-get -qq -y update && apt-get -qq -y install qemu-user qemu-user-static binfmt-support xz-utils
RUN mkdir /chroot                                             \
 && tar xzf arch.tar.gz -C /chroot                            \
 && tar xzf stack.tar.gz -C /chroot/root                      \
 && cp /chroot/root/stack-*/stack /chroot/usr/local/bin/stack \
 && tar xvJf ghc.tar.xz -C /chroot/root                       \
 && rm ghc.tar.xz stack.tar.gz arch.tar.gz                    \
 && apt-get clean
COPY scripts/prepare-chroot.sh scripts/setup-chroot.sh /
