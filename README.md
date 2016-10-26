## What is it?

A docker container preconfigured to run GHC and Stack in an arm7h (or other) Linux environment, suitable for compiling binaries for a C.H.I.P. and probably other similar things like Raspberry Pis.

## How do I build it?

Run `./build.sh`.

## How do I use it?

Run `./enter.sh` to open a shell inside the chroot. It'll volume mount the current directory into `/project` of the chroot.

If you want to pass options to docker, use `DOCKER_OPTS`, for example:

```
DOCKER_OPTS="…" ./enter.sh
```

## How does it work?

It's an Ubuntu image with `qemu-user-static` and `binfmt_misc` support installed. `qemu-arm-static` is registered with the Linux kernel's `binfmt_misc` support so that ARM binaries are dynamically translated into Intel ones as they're executed. A chroot filesystem is created which has an entire copy of Arch Linux precompiled for ARM, into which the necessary packages for GHC and Stack to function are installed, then GHC and Stack precompiled ARM binaries are also installed.

When you run `./enter.sh` it'll start the container in privileged mode on account of having to do `mount --bind` and similar trickery to get the chroot container right. When the container launches, the `prepare-chroot.sh` script sets up all the VFS mappings and so on to make the chroot fully functional, then chroots in to the ARM `bash` in the Arch install.

## Does it work with Stack's built-in Docker support?

No, I don't think so. That's because to make the trickery work it has to enter the docker container and then enter the chroot. I think it's possible to make it work by putting in one of the entrypoint scripts that Stack expects, but I haven't done so.

## Is it huge?

Yes, it is huge. Some things could be done to shrink it:

* Only using `docker build` for the qemu install and doing the GHC, Stack, and Arch installs directly in a container where the archives and expanded GHC can be cleaned out before committing the result.
* Using something other than Ubuntu in the host container that's smaller.
