shopt -s extglob


#wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/include/kernel-6.12 -P include/

wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/target/linux/x86/Makefile -P target/linux/x86/
wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/include/kernel-6.12 -P include/
wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/target/linux/x86/Makefile -P target/linux/x86



wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/target/linux/generic/backport-6.6/192-v6.12-fix-libbpf-Wmaybe-uninitialized.patch target/linux/x86/patches-6.12
#git_clone_path 6.12 https://github.com/namiltd/openwrt include include
git_clone_path master https://github.com/coolsnowwolf/lede package package

rm -rf package/kernel/rtw88-usb



wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/gpio-button-hotplug/src/gpio-button-hotplug.c -P package/kernel/gpio-button-hotplug/src
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/lantiq/ltq-adsl-mei/src/drv_mei_cpe.c -P package/kernel/lantiq/ltq-adsl-mei/src
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/lantiq/ltq-atm/src/ltq_atm.c -P package/kernel/lantiq/ltq-atm/src
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/lantiq/ltq-deu/src/ifxmips_deu.c -P package/kernel/lantiq/ltq-deu/src
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/lantiq/ltq-ptm/src/ifxmips_ptm_adsl.c -P package/kernel/lantiq/ltq-ptm/src
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/lantiq/ltq-ptm/src/ifxmips_ptm_vdsl.c -P package/kernel/lantiq/ltq-ptm/src
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/package/kernel/ubootenv-nvram/src/ubootenv-nvram.c -P package/kernel/ubootenv-nvram/src



rm -rf package/lean
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/files target/linux/generic/files
git_clone_path 6.12 https://github.com/namiltd/openwrt package/kernel/linux/modules package/kernel/linux/modules
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/hack-6.12 target/linux/generic/hack-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/backport-6.12 target/linux/generic/backport-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/pending-6.12 target/linux/generic/pending-6.12
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/x86/patches-6.12 target/linux/x86/patches-6.12
git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/files-6.12 target/linux/generic/files

