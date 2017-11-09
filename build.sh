#! /bin/bash

chrootbase_version_tag="jessie"
buildenv_version_tag="jessie-8.0.2-1.5.1-lts8.24"
prep_container_name=arm-stack-build-prep
chrootbase_image_name=rmacleod/arm-stack-chrootbase:$chrootbase_version_tag
buildenv_image_name=rmacleod/arm-stack-build:$buildenv_version_tag
arm32v7_debian_container_name=arm-stack-build-arm32v7-debian

mkdir -p dists

if [ ! -f dists/arm32v7-debian.tar ]; then
  echo "Grabbing arm32v7/debian:jessie filesystem..."
  [ $(docker ps -a -q -f name="$arm32v7_debian_container_name" | wc -l) -gt 0 ] && docker rm "$arm32v7_debian_container_name"
  docker container create --name "$arm32v7_debian_container_name" arm32v7/debian:jessie || exit 1
  docker container export "$arm32v7_debian_container_name" -o dists/arm32v7-debian.tar || exit 1
  docker container rm "$arm32v7_debian_container_name" || exit 1
fi

if [ ! -f dists/stack.tar.gz ]; then
  echo "Grabbing stack..."
  curl -L -o dists/stack.tar.gz "https://github.com/commercialhaskell/stack/releases/download/v1.5.1/stack-1.5.1-linux-arm.tar.gz" || exit 1
fi

if [ ! -f dists/clang+llvm.tar.xz ]; then
  echo "Grabbing clang+LLVM 3.7"
  curl -L -o dists/clang+llvm.tar.xz "http://releases.llvm.org/3.7.1/clang+llvm-3.7.1-armv7a-linux-gnueabihf.tar.xz" || exit 1
fi

if [ $(docker ps -a -q -f name="$prep_container_name" | wc -l) -gt 0 ]; then
  docker rm "$prep_container_name"
fi

set -x

if [ $(docker images -f reference=$chrootbase_image_name -q | wc -l) -eq 0 ]; then
  docker build -f Dockerfile.chrootbase -t "$prep_container_name" . || exit 1
  docker run --privileged --name "$prep_container_name" "$prep_container_name" /setup-chrootbase.sh || exit 1
  docker commit --change='CMD "/bin/bash"' "$prep_container_name" "$chrootbase_image_name" || exit 1
  docker rm "$prep_container_name"
fi

if [ $(docker images -f reference=$buildenv_image_name -q | wc -l) -eq 0 ]; then
  docker build -f Dockerfile.buildenv -t "$prep_container_name" . || exit 1
  docker run --privileged --name "$prep_container_name" "$prep_container_name" /setup-buildenv.sh || exit 1
  docker commit --change='CMD "bin/bash"' "$prep_container_name" "$buildenv_image_name" || exit 1
  docker rm "$prep_container_name"
fi


