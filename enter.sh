#! /bin/bash

docker run                              \
  --privileged                          \
  --rm                                  \
  -t -i                                 \
  -v "$(pwd):/project"                  \
  $DOCKER_OPTS                          \
  rmacleod/arm-stack-build:jessie-8.0.2-1.5.1 \
  "/prepare-chroot.sh; chroot /chroot /bin/bash"
