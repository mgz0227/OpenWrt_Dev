#!/bin/bash

shopt -s extglob

rm -rf target/linux package/kernel package/boot package/firmware

mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/master

cp -rf --parents target/linux package/kernel package/boot package/firmware include/kernel* config/Config-images.in config/Config-kernel.in include/image*.mk include/trusted-firmware-a.mk include/bpf.mk scripts/ubinize-image.sh package/utils/bcm27xx-utils package/devel/perf package/network/config/qosify ../
cd -
