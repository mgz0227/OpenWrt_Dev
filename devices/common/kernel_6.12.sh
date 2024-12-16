#!/bin/bash

shopt -s extglob

#!/bin/bash

# 删除旧文件夹（确保路径正确）
rm -rf target/linux package/kernel package/boot package/firmware include scripts  package/network config

git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux target/linux
git_clone_path 6.12 https://github.com/namiltd/openwrt package/kernel package/kernel
git_clone_path 6.12 https://github.com/namiltd/openwrt package/boot package/boot
git_clone_path 6.12 https://github.com/namiltd/openwrt package/network/config/qosify package/network/config/qosify

wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/kernel-6.12 -P include/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/kernel-build.mk -P include/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/kernel-defaults.mk -P include/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/kernel-version.mk -P include/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/kernel.mk -P include/

wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/image-commands.mk -P include/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/include/bpf.mk -P include/


wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/trusted-firmware-a.mk -P include/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/include/trusted-firmware-a.mk -P include/

wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/config/Config-images.in -P config/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/config/Config-kernel.in -P config/

wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/scripts/ubinize-image.sh -P scripts/
wget -N https://raw.githubusercontent.com/namiltd/openwrt/6.12/scripts/target-metadata.pl -P scripts/




 package/network/config/qosify


# 克隆指定分支代码
#git clone -b 6.12 --single-branch https://github.com/namiltd/openwrt.git || {



cd openwrt

# 将需要的文件和目录复制到当前工作目录
#cp -rf --parents target/linux package/kernel package/boot package/firmware include/kernel* config/Config-images.in config/Config-kernel.in include/image*.mk include/trusted-firmware-a.mk include/bpf.mk scripts/ubinize-image.sh scripts/target-metadata.pl package/utils/bcm27xx-utils package/devel/perf package/network/config/qosify ../../

cd ../../
# 清理临时文件夹
#rm -rf "$TEMP_DIR"


sed -i "s/^.*vermagic$/\techo '1' > \$(LINUX_DIR)\/.vermagic/" include/kernel-defaults.mk


git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/hack-6.12



wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/


#wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/include/u-boot.mk -P include/

