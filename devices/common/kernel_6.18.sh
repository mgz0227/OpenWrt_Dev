#!/bin/bash

shopt -s extglob

rm -rf target/linux package/boot package/devel package/firmware package/kernel package/libs package/network tools toolchain
mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/master

cp -rf --parents target/linux package/boot package/devel package/firmware package/kernel package/libs package/network tools toolchain config ../
rm -rf target/linux/bcm53xx
cd -

cd package
rm -rf kernel/linux/modules/crypto.mk kernel/linux/modules/lib.mk kernel/mac80211/patches/build/999-fix_build_on_6_18.patch
git_clone_path 6.18 https://github.com/namiltd/openwrt/ kernel/linux/modules kernel/mac80211
cd ../

rm -rf target/linux/generic
git_clone_path 6.18 https://github.com/namiltd/openwrt/ target/linux/generic

rm -rf target/linux/x86
git_clone_path 6.18.y https://github.com/mgz0227/openwrt target/linux/x86







cd feeds/packages
rm -rf net/xtables-addons net/strongswan utils/coremark lang/golang utils/open-vm-tools libs/rpcsvc-proto libs
git_clone_path master https://github.com/openwrt/packages net/xtables-addons net/strongswan lang/golang utils/open-vm-tools libs/rpcsvc-proto libs
cd ../../




#cd package
#rm -rf devel/kselftests-bpf 
#devel/perf
#cd ../
