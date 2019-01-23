# fwts-live
This is the repository containing the codes and instructions to build
a FWTS (Firmware Test Suite) live image, which is based on a Ubuntu
system.

# Build
Clone this repository, then run:

    sudo apt install docker.io
    sudo make

The generated image will be called `pc.img` in the local directory.

# TODO
Make the image smaller by pruning unnecessary packages.
