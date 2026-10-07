#!/bin/bash
# Run with: bash tests/kernel_7.3.sh
set -e

script="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/devices/common/kernel_7.3.sh"
test_root=$(mktemp -d "${TMPDIR:-/tmp}/kernel-7.3-test.XXXXXX")
[[ "$test_root" = /*/kernel-7.3-test.* ]]
trap 'rm -rf -- "$test_root"' EXIT
export fixture="$test_root/source"

dirs=(include target/linux package/boot package/devel package/firmware package/kernel package/libs package/network tools toolchain config)
files=(rules.mk target/Config.in scripts/target-metadata.pl scripts/cache-run.sh scripts/build-time-log.sh)
for path in "${dirs[@]}"; do
    mkdir -p "$fixture/$path" "$test_root/work/$path"
    echo kernel-7.3 > "$fixture/$path/source"
    echo original > "$test_root/work/$path/old"
done
for path in "${files[@]}"; do
    mkdir -p "$fixture/$(dirname "$path")" "$test_root/work/$(dirname "$path")"
    echo kernel-7.3 > "$fixture/$path"
    echo original > "$test_root/work/$path"
done
mkdir -p "$test_root/work/feeds/packages" "$test_root/work/.git"
echo official-origin > "$test_root/work/.git/config"
cp -r "$test_root/work" "$test_root/failed"

# Replace only network operations; exercise the script's real deletion/copy commands.
git() {
    [[ "$*" = 'clone --depth 1 --single-branch --branch kernel-7.3 https://github.com/graysky2/openwrt new' ]] || return 1
    [[ "${FAIL_CLONE:-0}" = 0 && ! -e new ]] || return 1
    cp -r "$fixture" new
}
git_clone_path() { :; }
export -f git git_clone_path

cd "$test_root/work"
bash "$script"
for path in "${dirs[@]}"; do
    [[ "$(cat "$path/source")" = kernel-7.3 ]]
    [[ "$path" = config || ! -e "$path/old" ]]
done
for path in "${files[@]}"; do
    [[ "$(cat "$path")" = kernel-7.3 ]]
done
[[ "$(cat config/old)" = original && "$(cat .git/config)" = official-origin ]]

cd "$test_root/failed"
if FAIL_CLONE=1 bash "$script"; then
    echo 'Expected clone failure' >&2
    exit 1
fi
for path in "${dirs[@]}"; do
    [[ "$(cat "$path/old")" = original && ! -e "$path/source" ]]
done
for path in "${files[@]}"; do
    [[ "$(cat "$path")" = original ]]
done
[[ "$(cat .git/config)" = official-origin && ! -e new ]]
echo 'PASS: branch copy, config merge, original Git metadata, clone failure preservation'

# Exercise the workflow's version output and rejection of invalid/failed queries.
version_step=$(awk '/    - name: Get kernel version/{step=1; next} step && /      run: \|/{body=1; next} body && /^        /{sub(/^        /, ""); print; next} body{exit}' "$(dirname "$script")/../../.github/workflows/Openwrt-AutoBuild.yml")
mkdir openwrt
make() { printf '%s\n' "$TEST_KERNEL_VERSION"; return "${TEST_MAKE_STATUS:-0}"; }
export -f make
export GITHUB_ENV="$test_root/kernel.env"
for value in 6.18.55 7.3-rc6 7.3; do
    : > "$GITHUB_ENV"
    TEST_KERNEL_VERSION="$value" bash -e -c "$version_step"
    [[ "$(cat "$GITHUB_ENV")" = "KERNEL_VER=$value" ]]
done
for value in '' build.mk.; do
    : > "$GITHUB_ENV"
    if TEST_KERNEL_VERSION="$value" bash -e -c "$version_step"; then
        echo 'Expected invalid version rejection' >&2
        exit 1
    fi
    [[ ! -s "$GITHUB_ENV" ]]
done
if TEST_KERNEL_VERSION=7.3 TEST_MAKE_STATUS=1 bash -e -c "$version_step"; then
    echo 'Expected make failure' >&2
    exit 1
fi
echo 'PASS: kernel version output and failure handling'
