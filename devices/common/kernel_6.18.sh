#!/bin/bash
# =================================================
# 内核与 Target 同步更新脚本
# 目的：从 mgz0227/openwrt 的 6.18.y 分支同步关键目录，
#       同时强制保留并重拉 x86 与 generic 目录，避免 bcm53xx fallback。
# =================================================

set -e
shopt -s extglob

echo "🧹 清理旧源码树..."
rm -rf target/linux package/boot package/devel package/firmware package/kernel package/libs package/network tools toolchain

mkdir new && cp -rf .git new/.git
cd new

echo "📦 重置到 6.18.y 分支最新版本..."
git fetch origin 6.18.y --depth=1
git checkout 6.18.y
git reset --hard origin/6.18.y

echo "📤 复制需要的目录回主工程..."
cp -rf --parents target/linux package/boot package/devel package/firmware \
       package/kernel package/libs package/network tools toolchain config ../

cd ..

# ⚙️ 保留 generic 与 x86，其余 target 全删
echo "🧩 清理多余的 target..."
if [ -d target/linux ]; then
    find target/linux -mindepth 1 -maxdepth 1 ! -name 'generic' ! -name 'x86' -exec rm -rf {} +
fi

# ♻️ 重拉最新版 generic 与 x86（确保干净）
echo "🔁 重新获取 generic 与 x86 目录..."
rm -rf target/linux/generic
git_clone_path 6.18.y https://github.com/mgz0227/openwrt target/linux/generic

rm -rf target/linux/x86
git_clone_path 6.18.y https://github.com/mgz0227/openwrt target/linux/x86

# 验证两个关键目录是否存在
echo "✅ 验证拉取结果："
ls target/linux | grep -E "x86|generic" || (echo "❌ 关键 target 丢失" && exit 1)

# =================================================
# feeds 更新部分
# =================================================
echo "🔄 更新部分外部 feeds..."
cd feeds/packages
rm -rf net/xtables-addons net/strongswan utils/coremark lang/golang utils/open-vm-tools libs/rpcsvc-proto libs
git_clone_path master https://github.com/openwrt/packages net/xtables-addons net/strongswan lang/golang utils/open-vm-tools libs/rpcsvc-proto libs
cd ../../

echo "🎯 Target Linux 同步完毕"



#cd package
#rm -rf devel/kselftests-bpf 
#devel/perf
#cd ../
