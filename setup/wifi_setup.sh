#!/bin/bash

apt-get install curl build-essential
ls -l /lib/modules
FIRMWARE_REV=`cat /boot/.firmware_revision`
KERNEL_REV=`curl -L https://github.com/Hexxeh/rpi-firmware/raw/${FIRMWARE_REV}/git_hash`
curl -L https://github.com/Hexxeh/rpi-firmware/raw/${FIRMWARE_REV}/Module7.symvers >Module7.symver
curl -L https://github.com/raspberrypi/linux/archive/${KERNEL_REV}.tar.gz >rpi-linux.tar.gz

cd /usr/src
mkdir rpi-linux
cd rpi-linux
tar --strip-components 1 -xf /home/pi/rpi-linux.tar.gz
modprobe configs
gunzip -c /proc/config.gz >.config
cp $HOME/Module7.symvers Module.symvers

make modules_prepare
ln -sv /usr/src/rpi-linux /lib/modules/$(uname -r)/build

cd /home/pi/MeshTest/
make

