#!/bin/bash

shopt -s extglob

# 删除旧文件夹
rm -rf target/linux package/kernel package/boot package/firmware

# 创建临时文件夹存放新代码
mkdir new
cd new

# 克隆指定分支的代码
git clone -b 6.12 --single-branch https://github.com/namiltd/openwrt.git

# 返回到上一层目录
cd ..

# 将所需文件和目录复制到当前目录（上一级目录）
cp -rf --parents \
    target/linux \
    package/kernel \
    package/boot \
    package/firmware \
    include/kernel* \
    config/Config-images.in \
    config/Config-kernel.in \
    include/image*.mk \
    include/trusted-firmware-a.mk \
    include/bpf.mk \
    scripts/ubinize-image.sh \
    scripts/target-metadata.pl \
    package/utils/bcm27xx-utils \
    package/devel/perf \
    package/network/config/qosify \
    new/openwrt/* .

# 清理临时文件夹
rm -rf new

sed -i "s/^.*vermagic$/\techo '1' > \$(LINUX_DIR)\/.vermagic/" include/kernel-defaults.mk


git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/hack-6.12



wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/


#wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/include/u-boot.mk -P include/

