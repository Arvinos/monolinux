#!/usr/bin/env bash

set -e

BUILD=$1
INITRAMFS_FILES=$2

rm -rf $BUILD/initramfs
mkdir -p $BUILD/initramfs
cd $BUILD/initramfs
mkdir -p {dev,etc,mnt/disk,proc,root,sys/kernel/debug}
cp -a /dev/{null,console,tty,urandom,kmsg} dev
cp $BUILD/app init
chmod +x init
echo "nameserver 8.8.4.4" > etc/resolv.conf
cd - > /dev/null

for file in $INITRAMFS_FILES ; do
    echo "Copying $file to /root in the initramfs."
    cp $file $BUILD/initramfs/root
done

cd $BUILD/initramfs
find . | cpio -H newc -o > ../initramfs.cpio
