#!/bin/bash

shopt -s extglob

rm -rf target/linux package/boot package/devel package/firmware package/kernel package/libs package/network package/kernel tools toolchain
mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/6.18.y

cp -rf --parents target/linux package/boot package/devel package/firmware package/kernel package/libs package/network package/kernel tools toolchain config ../
rm -rf target/linux/bcm53xx
cd -


#wget -N https://github.com/immortalwrt/immortalwrt/raw/refs/heads/openwrt-25.12/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/





cd feeds/packages
rm -rf libs/libpfring net/xtables-addons
cd ../../

cd feeds/miaogongzi
rm -rf fibocom_QMI_WWAN
cd ../../


cd package
rm -rf devel/kselftests-bpf kernel/r8101 kernel/r8125 kernel/r8126 kernel/r8169
#devel/perf
cd ../


#sed -i -E 's/^CONFIG_PACKAGE_kmod-(mac80211|cfg80211)=m$/# & is not set/' .config
#sed -i -E 's/^CONFIG_PACKAGE_kmod-(ath9k|ath9k-common|ath5k|iwlwifi|mt76.*)=m$/# & is not set/' .config
#sed -i -E 's/^CONFIG_PACKAGE_(MAC80211|CFG80211)_.+=y$/# & is not set/' .config
