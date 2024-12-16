#!/bin/bash

shopt -s extglob

rm -rf target/linux package/kernel package/boot package/firmware

mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/master

cp -rf --parents target/linux package/kernel package/boot package/firmware include/kernel* config/Config-images.in config/Config-kernel.in include/image*.mk include/trusted-firmware-a.mk include/bpf.mk scripts/ubinize-image.sh scripts/target-metadata.pl package/utils/bcm27xx-utils package/devel/perf package/network/config/qosify ../
cd -

sed -i "s/^.*vermagic$/\techo '1' > \$(LINUX_DIR)\/.vermagic/" include/kernel-defaults.mk


git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/hack-6.12



wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/


#wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/include/u-boot.mk -P include/

