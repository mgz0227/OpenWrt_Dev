#!/bin/bash

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

#bash $SHELL_FOLDER/../common/kernel_6.6.sh

git_clone_path master https://github.com/coolsnowwolf/lede target/linux/x86/files target/linux/x86/patches-6.12

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/x86/base-files/etc/board.d/02_network -P target/linux/x86/base-files/etc/board.d/

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/x86/64/config-6.12 -P target/linux/x86/64/

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/firmware/linux-firmware/intel.mk -P package/firmware/linux-firmware/

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/
#内核升级模块
#开始
#rm -rf target/linux/generic/backport-6.6/777-netfilter-xtables-fix-typo-causing-some-targets-to-not-load-on-IPv6.patch
#rm -rf target/linux/generic/backport-6.6/780-24-v6.12-r8169-avoid-unsolicited-interrupts.patch
#rm -rf target/linux/generic/backport-6.6/409-mtd-spi-nor-winbond-fix-w25q128-regression.patch

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/usb.mk -P package/kernel/linux/modules/
rm -rf target/linux/stm32/modules.mk

rm -rf target/linux/generic/hack-6.12/531-debloat_lzma.patch
rm -rf target/linux/generic/hack-6.12/410-block-fit-partition-parser.patch
#wget -N https://raw.githubusercontent.com/openwrt/openwrt/openwrt-24.10/package/kernel/mac80211/patches/build/236-fix-genlmsg_multicast_allns-build-error-on-kernel-6.6.59.patch -P package/kernel/mac80211/patches/build/

#wget -N https://raw.githubusercontent.com/mgz0227/openwrt/main/include/kernel-6.6 -P include/

#结束

sed -i 's/kmod-r8169/kmod-r8168/' target/linux/x86/image/64.mk

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-usb-hid kmod-mmc kmod-sdhci usbutils pciutils lm-sensors-detect kmod-atlantic kmod-vmxnet3 kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-r8101 kmod-r8125 kmod-r8126 kmod-8139cp kmod-8139too kmod-i40e kmod-drm-i915 kmod-drm-amdgpu kmod-mlx4-core kmod-mlx5-core fdisk lsblk kmod-phy-broadcom kmod-ixgbevf/' target/linux/x86/Makefile

mv -f tmp/r81* feeds/miaogongzi/

sed -i 's/256/1024/g' target/linux/x86/image/Makefile


