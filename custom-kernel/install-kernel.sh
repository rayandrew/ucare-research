#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

echo "Compiling Linux Kernel"

make -j $(nproc)

echo "Installing kernel modules"

sudo make modules_install

echo "Install linux kernel"

sudo make install

echo "Update initramfs and grub (if exist)"

sudo update-initramfs -c -k 5.2.8

sudo update-grub

echo "Done installing Linux Kernel, Have fun :)"
