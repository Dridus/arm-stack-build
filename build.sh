#! /bin/bash

prep_container_name=arm-stack-build-prep
image_name=rmacleod/arm-stack-build:latest
stack_tar=
ghc_tar=

if [ ! -f dists/arch.tar.gz ]; then
  echo "Grabbing Arch Linux ARM filesystem..."
  curl -L -o dists/arch.tar.gz "http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz" || exit 1
fi

if [ ! -f dists/stack.tar.gz ]; then
  echo "Grabbing stack..."
  curl -L -o dists/stack.tar.gz "https://github.com/commercialhaskell/stack/releases/download/v1.1.2/stack-1.1.2-linux-arm.tar.gz" || exit 1
fi

if [ ! -f dists/ghc.tar.xz ]; then
  echo "Grabbing GHC..."
  curl -L -o dists/ghc.tar.xz "https://downloads.haskell.org/~ghc/8.0.1/ghc-8.0.1-armv7-deb8-linux.tar.xz" || exit 1
fi

if [ $(docker ps -a -q -f name="$prep_container_name" | wc -l) -gt 0 ]; then
  docker rm "$prep_container_name"
fi

set -x

docker build -t "$prep_container_name" . || exit 1
docker run --privileged --name "$prep_container_name" "$prep_container_name" /setup-chroot.sh || exit 1
docker commit --change='CMD "/bin/bash"' "$prep_container_name" "$image_name" || exit 1
docker rm "$prep_container_name"



