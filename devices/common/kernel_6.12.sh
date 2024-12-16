#!/bin/bash

shopt -s extglob

#!/bin/bash

# 删除旧文件夹（确保路径正确）
rm -rf target/linux package/kernel package/boot package/firmware include scripts package/devel package/network config

# 创建临时目录存放新代码
TEMP_DIR="new"
rm -rf "$TEMP_DIR"
mkdir "$TEMP_DIR"
cd "$TEMP_DIR"

# 克隆指定分支代码
git clone -b 6.12 --single-branch https://github.com/namiltd/openwrt.git || {
    echo "Error: Failed to clone repository."
    exit 1
}

# 检查克隆是否成功
if [ ! -d "openwrt" ]; then
    echo "Error: Repository not cloned correctly."
    exit 1
fi

# 返回到主目录
cd ..

# 将需要的文件和目录复制到当前工作目录
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
    "$TEMP_DIR/openwrt" .

# 清理临时文件夹
rm -rf "$TEMP_DIR"

# 检查关键文件是否存在
if [ ! -f "target/linux/x86/image/64.mk" ] || [ ! -f "target/linux/x86/image/Makefile" ]; then
    echo "Error: Required files are missing. Check the repository content."
    exit 2
fi

sed -i "s/^.*vermagic$/\techo '1' > \$(LINUX_DIR)\/.vermagic/" include/kernel-defaults.mk


git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/hack-6.12



wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -P package/kernel/linux/modules/


#wget -N https://raw.githubusercontent.com/openwrt/openwrt/main/include/u-boot.mk -P include/

