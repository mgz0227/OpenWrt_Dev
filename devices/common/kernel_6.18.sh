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
rm -rf libs/libpfring/patches/*
rm -rf libs/libpfring/Makefile
wget -N https://raw.githubusercontent.com/graysky2/packages/91f0b3e8621ae529d01356bfe411c91d25e22b4b/libs/libpfring/patches/0001-fix-cross-compiling.patch -P libs/libpfring/patches/
wget -N https://raw.githubusercontent.com/graysky2/packages/91f0b3e8621ae529d01356bfe411c91d25e22b4b/libs/libpfring/patches/010-gcc14.patch -P libs/libpfring/patches/
wget -N https://raw.githubusercontent.com/graysky2/packages/91f0b3e8621ae529d01356bfe411c91d25e22b4b/libs/libpfring/patches/100-fix-compilation-warning.patch -P libs/libpfring/patches/
wget -N https://raw.githubusercontent.com/graysky2/packages/91f0b3e8621ae529d01356bfe411c91d25e22b4b/libs/libpfring/patches/200-net-s-dev_get_flags-netif_get_flags.patch -P libs/libpfring/patches/
wget -N https://raw.githubusercontent.com/graysky2/packages/91f0b3e8621ae529d01356bfe411c91d25e22b4b/libs/libpfring/Makefile -P libs/libpfring/
cd ../../



cd feeds/packages
rm -rf net/xtables-addons net/jool kernel/v4l2loopback
#libs/libpfring
git_clone_path master https://github.com/openwrt/packages net/jool kernel/v4l2loopback
git_clone_path 6.18-xt-addons https://github.com/graysky2/packages net/xtables-addons
wget -N https://raw.githubusercontent.com/graysky2/packages/c55afaa2bebca50a0e019a249c2748e7d7f745b7/kernel/ovpn-dco/Makefile -P kernel/ovpn-dco/


cd ../../

#cd feeds/routing
#rm -rf batman-adv
#cd ../../

#cd feeds/miaogongzi
#rm -rf fibocom_QMI_WWAN
#cd ../../


cd package
rm -rf devel/kselftests-bpf  libs/libnl/Makefile kernel/r8168  kernel/rtl8812au-ct kernel/ath10k-ct
wget -N https://cdn.mgz.la/openwrt/add-kernel-6.18-timer-API-compatibility.patch -P kernel/mt76/patches/
wget -N https://raw.githubusercontent.com/graysky2/openwrt/061613c6ec0353d2ca70f8e15d47c1a6ed70f501/package/libs/libnl/Makefile -P libs/libnl/ 
#devel/perf kernel/mt76
cd ../


#sed -i -E 's/^CONFIG_PACKAGE_kmod-(mac80211|cfg80211)=m$/# & is not set/' .config
#sed -i -E 's/^CONFIG_PACKAGE_kmod-(ath9k|ath9k-common|ath5k|iwlwifi|mt76.*)=m$/# & is not set/' .config
#sed -i -E 's/^CONFIG_PACKAGE_(MAC80211|CFG80211)_.+=y$/# & is not set/' .config
