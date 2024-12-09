shopt -s extglob


wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/include/kernel-6.12 -P include/

wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/target/linux/generic/backport-6.6/192-v6.12-fix-libbpf-Wmaybe-uninitialized.patch target/linux/x86/patches-6.12
#git_clone_path 6.12 https://github.com/namiltd/openwrt include include
git_clone_path master https://github.com/coolsnowwolf/lede package package

rm -rf package/libs/mbedtls/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/libs/mbedtls package/libs/mbedtls

rm -rf package/network/utils/linux-atm/*
git_clone_path openwrt-24.10 https://github.com/openwrt/openwrt package/network/utils/linux-atm package/network/utils/linux-atm

rm -rf package/lean
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/hack-6.12 target/linux/generic/hack-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/backport-6.12 target/linux/generic/backport-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/pending-6.12 target/linux/generic/pending-6.12
git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/files-6.12 target/linux/generic/files
