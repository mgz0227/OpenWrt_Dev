#!/bin/bash

shopt -s extglob

rm -rf target/linux package/kernel package/boot package/firmware

mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/master

cp -rf --parents target/linux package/kernel package/boot package/firmware include/kernel* config/Config-images.in config/Config-kernel.in include/image*.mk include/trusted-firmware-a.mk scripts/ubinize-image.sh package/utils/bcm27xx-utils package/network/config/qosify ../
cd -
cd openwrt
rm -rf ./feeds/packages/net/xtables-addons
cd -
#find . -type d -name xtables-addons
#sudo find / -type d -name xtables-addons 2>/dev/null
