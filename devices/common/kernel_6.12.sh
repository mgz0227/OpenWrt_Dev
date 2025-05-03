#!/bin/bash

shopt -s extglob

rm -rf target/linux package/kernel
mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/master

cp -rf --parents target/linux package/kernel config/Config-kernel.in ../
cd -

cd feeds/packages
rm -rf kernel/ovpn-dco libs/xr_usb_serial_common net/xtables-addons
#rm -rf net/xtables-addons 



cd ../../

cd feeds/pakage
rm -rf kernel/mt76 kernel/mt7621-qtn-rgmii devel/kselftests-bpf devel/perf

cd ../../
