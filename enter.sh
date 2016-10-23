#! /bin/bash

docker run                              \
  --privileged                          \
  -t -i                                 \
  $DOCKER_OPTS                          \
  rmacleod/haskell-arm-build-env:latest \
  "/prepare-chroot.sh; chroot /chroot /bin/bash"
