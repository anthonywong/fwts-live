# FWTS live

[![Build Status](https://travis-ci.org/anthonywong/fwts-live.svg?branch=master)](https://travis-ci.org/anthonywong/fwts-live)

This is the repository containing the codes and instructions to build
a [FWTS](https://wiki.ubuntu.com/FirmwareTestSuite) (Firmware Test Suite) [live image](https://wiki.ubuntu.com/FirmwareTestSuite/FirmwareTestSuiteLive), which is based on a Ubuntu
system.

# Build

## By Docker (amd64)
Clone this repository, then run:

```sh
$ sudo apt install docker.io
$ sudo make
```

The generated image will be called `fwts-live-<version>.img.xz` in the local directory.

## By commands (amd64)
If you don't want to use docker, you can run the follow commands in
Ubuntu 16.04 or 18.04 as root:

```sh
# echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic-security main universe" >> /etc/apt/sources.list 
# apt update && apt -y install build-essential git snapcraft ubuntu-image && apt-get -y build-dep livecd-rootfs
# git clone --depth 1 https://github.com/anthonywong/pc-amd64-gadget.git && \
    cd pc-amd64-gadget && snapcraft prime
# git clone --depth 1 https://github.com/anthonywong/fwts-livecd-rootfs.git && \
    cd fwts-livecd-rootfs && debian/rules binary && \
    dpkg -i ../livecd-rootfs_*_amd64.deb
# ubuntu-image classic -a amd64 -d -p ubuntu-cpc -s bionic -i 850M -O /image \
    --extra-ppas firmware-testing-team/ppa-fwts-stable pc-amd64-gadget/prime && \
    fwts_version=$(apt-cache show fwts | grep ^Version | egrep -o '[0-9]{2}.[0-9]{2}.[0-9]{2}' | sort -r | head -1) && \
    mv /image/pc.img /image/fwts-live-${fwts_version}.img && \
    xz /image/fwts-live-${fwts_version}.img
```

## By commands (aarch64)
The following command is for building on an aarch64 host:

```sh
# echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main universe" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ bionic-security main universe" >> /etc/apt/sources.list 
# apt update && apt -y install build-essential git snapcraft ubuntu-image && apt-get -y build-dep livecd-rootfs
# git clone --depth 1 https://github.com/anthonywong/uefi-aarch64-gadget.git && \
    cd uefi-aarch64-gadget && snapcraft prime
# git clone --depth 1 https://github.com/anthonywong/fwts-livecd-rootfs.git && \
    cd fwts-livecd-rootfs && debian/rules binary && \
    dpkg -i ../livecd-rootfs_*_arm64.deb
# ubuntu-image classic -a arm64 -d -p ubuntu-cpc -s bionic -O ~/image \
    --extra-ppas firmware-testing-team/ppa-fwts-stable pc-amd64-gadget/prime && \
    fwts_version=$(apt-cache show fwts | grep ^Version | egrep -o '[0-9]{2}.[0-9]{2}.[0-9]{2}' | sort -r | head -1) && \
    mv /image/pc.img /image/fwts-live-${fwts_version}-arm64.img && \
    xz /image/fwts-live-${fwts_version}-arm64.img
```

# Testing
The image can be easily tested using kvm.

* amd64:
```sh
$ kvm -m 1024 -drive file=fwts-live-<version>.img,format=raw
```

* aarch64:
```sh
$ sudo apt install qemu-system-arm qemu-efi-aarch64 
$ qemu-system-aarch64 -nographic -cpu cortex-a53 -M virt -m 1024 \
  -bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd \
  -drive if=virtio,format=raw,file=fwts-live-<version>-arm64.img
```

# TODO
Make the image smaller by pruning unnecessary packages.
