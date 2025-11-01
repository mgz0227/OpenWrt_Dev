#!/bin/bash

shopt -s extglob

rm -rf target/linux package/boot package/devel package/firmware package/kernel package/libs package/network tools toolchain
mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/6.18.y

cp -rf --parents target/linux package/boot package/devel package/firmware package/kernel package/libs package/network tools toolchain config ../
find target/linux -mindepth 1 -maxdepth 1 ! -name 'generic' ! -name 'x86' -exec rm -rf {} +
cd -

cd feeds/packages
rm -rf net/xtables-addons net/strongswan utils/coremark lang/golang utils/open-vm-tools libs/rpcsvc-proto libs
git_clone_path master https://github.com/openwrt/packages net/xtables-addons net/strongswan lang/golang utils/open-vm-tools libs/rpcsvc-proto libs
cd ../../


#cd package
#rm -rf devel/kselftests-bpf 
#devel/perf
#cd ../
