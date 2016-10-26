#! /bin/bash

docker run                              \
  --privileged                          \
  --rm                                  \
  -t -i                                 \
  -v "$(pwd):/project"                  \
  $DOCKER_OPTS                          \
  rmacleod/arm-stack-build:latest       \
  "/prepare-chroot.sh; chroot /chroot /bin/bash"
