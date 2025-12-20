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
rm -rf libs/libpfring
cd ../../

cd feeds/miaogongzi
rm -rf fibocom_QMI_WWAN
cd ../../


cd package
rm -rf devel/kselftests-bpf kernel/r8101 
#devel/perf
cd ../

echo "🔧 Disabling sound packages (soft-router build)"
# 关掉所有 sound / alsa / usb-audio 相关包选择
sed -i -E '
  s/^(CONFIG_PACKAGE_kmod-(sound|snd-|usb-audio|ac97|pcspkr).*)=.*/# \1 is not set/;
  s/^(CONFIG_PACKAGE_alsa-lib)=.*/# \1 is not set/;
  s/^(CONFIG_PACKAGE_alsa-utils)=.*/# \1 is not set/;
' .config
# 彻底关掉 mac80211 / cfg80211 / wifi 驱动，避免 backports 编译 ath9k
sed -n '/# Wireless Drivers/,/# end of Wireless Drivers/p' .config | sed -e 's/=m/=n/' >> .config
sed -i "s/\(kmod-qca.*\)=m/\1=n/" .config
sed -i -E 's/^CONFIG_PACKAGE_kmod-(mac80211|cfg80211)=m$/# & is not set/' .config
sed -i -E 's/^CONFIG_PACKAGE_kmod-(ath9k|ath9k-common|ath5k|iwlwifi|mt76.*)=m$/# & is not set/' .config
sed -i -E 's/^CONFIG_PACKAGE_(MAC80211|CFG80211)_.+=y$/# & is not set/' .config
