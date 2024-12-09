shopt -s extglob


wget -N https://raw.githubusercontent.com/mgz0227/Openwrt_6.12/main/include/kernel-6.12 -P include/

rm -rf package/*
#git_clone_path 6.12 https://github.com/namiltd/openwrt include include
git_clone_path master https://github.com/coolsnowwolf/lede package package
rm -rf package/lean
git_clone_path 6.12 https://github.com/namiltd/openwrt target/linux/generic/hack-6.12 target/linux/generic/hack-6.12

git_clone_path master https://github.com/coolsnowwolf/lede target/linux/generic/files-6.12 target/linux/generic/files