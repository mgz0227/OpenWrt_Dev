shopt -s extglob


#wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/include/kernel-6.12 -P include/

wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/target/linux/x86/Makefile -P target/linux/x86/
wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/include/kernel-6.12 -P include/
wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/target/linux/x86/Makefile -P target/linux/x86



wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/target/linux/generic/backport-6.6/192-v6.12-fix-libbpf-Wmaybe-uninitialized.patch target/linux/x86/patches-6.12
#git_clone_path 6.12 https://github.com/namiltd/openwrt include include
git_clone_path master https://github.com/coolsnowwolf/lede package package

rm -rf package/libs/mbedtls/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/libs/mbedtls package/libs/mbedtls

rm -rf package/network/utils/linux-atm/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/utils/linux-atm package/network/utils/linux-atm

rm -rf package/network/services/dropbear/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/services/dropbear package/network/services/dropbear

#rm -rf package/network/utils/tcpdump/*
#git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/utils/tcpdump package/network/utils/tcpdump

#rm -rf package/network/utils/iw/*
#git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/utils/iw package/network/utils/iw

#rm -rf package/network/utils/xdp-tools

rm -rf package/network/utils/iptables
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/utils/iptables package/network/utils/iptables

#rm -rf package/kernel/rtw88-usb/*
#git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/kernel/rtw88-usb package/kernel/rtw88-usb

#rm -rf package/network/utils/iproute2
#rm -rf package/network/utils/iproute2/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/utils/iproute2 package/network/utils/iproute2

rm -rf package/base-files/files/etc/iproute2/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/base-files/files/etc/iproute2 package/base-files/files/etc/iproute2

rm -rf package/network/services/hostapd/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/services/hostapd package/network/services/hostapd


git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/libs package/libs




rm -rf package/lean
git_clone_path 6.12 https://github.com/namiltd/openwrt package/kernel/linux/modules package/kernel/linux/modules
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/hack-6.12 target/linux/generic/hack-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/backport-6.12 target/linux/generic/backport-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/pending-6.12 target/linux/generic/pending-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/x86/patches-6.12 target/linux/x86/patches-6.12
git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/files-6.12 target/linux/generic/files
