"""Run: python tests/test_base_files_postinst.py; GNU PATCH and BASH may be overridden.

Downloads pinned upstream files and applies only the functions.sh/fwtool.sh hunks.
BASE_FILES_PATCH can select an older patch for a negative control. All filesystem
tests and service calls in default_postinst are mocked; no real services run.
"""
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from urllib.request import urlopen

REPO = Path(__file__).resolve().parents[1]
BASE = "c740570351512e4400369b3c2aff49741f65580e"
PATCH = os.environ.get("PATCH") or shutil.which("patch")
BASH = os.environ.get("BASH") or shutil.which("bash")
if os.name == "nt":
    PATCH = PATCH or "C:/Program Files/Git/usr/bin/patch.exe"
    BASH = BASH or "C:/Program Files/Git/bin/bash.exe"
assert PATCH and BASH, "GNU patch and Bash are required (or set PATCH/BASH)"
PATHS = ["package/base-files/files/lib/functions.sh",
         "package/base-files/files/lib/upgrade/fwtool.sh"]
patch_path = Path(os.environ.get("BASE_FILES_PATCH", REPO / "devices/common/patches/base-files.patch"))

# Keep the actual function unchanged. Virtual stat/grep and absolute-path Bash
# functions emulate its filesystem and init scripts without touching the host.
MOCKS = r'''
pkgname=probe
LISTPATH="$IPKG_INSTROOT/$LISTDIR/probe.list"
function [ {
    case "$1" in
        -f|-e) builtin [ "$2" = "$LISTPATH" ] || {
            builtin [ "$HAS_POSTINST" = 1 ] &&
            builtin [ "$2" = "$IPKG_INSTROOT/usr/lib/opkg/info/probe.postinst-pkg" ]; } ;;
        -d) return 1 ;;
        -x) case "$2" in /etc/init.d/rpcd|/etc/init.d/ucitrack) return 0;; *) return 1;; esac ;;
        *) builtin [ "$@" ;;
    esac
}
grep() {
    local args=("$@") last=$(($# - 1))
    [[ ${args[$last]} == "$LISTPATH" ]] || { echo "unexpected filelist" >&2; return 99; }
    args[$last]=fixture.list
    command grep "${args[@]}"
}
rm() { :; }
cp() { echo "unexpected copy" >&2; return 99; }
add_group_and_user() { :; }
update_alternatives() { echo "unexpected alternatives" >&2; return 99; }
function . { builtin source fixture.postinst; }
function /etc/init.d/rpcd { echo "rpcd $*"; }
function /etc/init.d/ucitrack { echo "ucitrack $*"; }
function /etc/init.d/probe {
    if [[ $1 == enabled ]]; then builtin [ "$ENABLED" = 1 ]; else echo "probe $*"; fi
}
'''


def bash(script, work, expected_status=0, **variables):
    result = subprocess.run([BASH, "--noprofile", "--norc", "-c", script], cwd=work,
                            env={**os.environ, **variables, "BASH_ENV": "/dev/null"},
                            text=True, capture_output=True)
    assert result.returncode == expected_status and not result.stderr, result
    return result.stdout.splitlines()


with tempfile.TemporaryDirectory(prefix="base-files-postinst-") as temp:
    work = Path(temp)
    for path in PATHS:
        target = work / path
        target.parent.mkdir(parents=True, exist_ok=True)
        with urlopen(f"https://raw.githubusercontent.com/openwrt/openwrt/{BASE}/{path}", timeout=30) as response:
            target.write_bytes(response.read())
    sections = re.split(r"(?=^--- a/)", patch_path.read_text(), flags=re.M)
    selected = "".join(part for part in sections if part.startswith(tuple("--- a/" + p + "\n" for p in PATHS)))
    assert selected, "no functions.sh/fwtool.sh patch sections found"
    subprocess.run([PATCH, "--binary", "--batch", "--fuzz=0", "-p1", "--forward"],
                   cwd=work, input=selected.encode(), check=True)
    source = (work / PATHS[0]).read_text()
    match = re.search(r"(?ms)^default_postinst\(\) \{\n.*?^\}", source)
    assert match, "default_postinst not found"
    function = match.group()
    for fmt, directory in [("APK", "lib/apk/packages"), ("opkg", "usr/lib/opkg/info")]:
        cases = [
            ("unrelated", "/usr/share/example/data", "", "0", "0", []),
            ("ACL", "/usr/share/rpcd/acl.d/probe.json", "", "0", "0", ["rpcd reload"]),
            ("ucitrack", "/usr/share/ucitrack/probe.json", "", "0", "0", ["ucitrack reload"]),
            ("both", "/usr/share/rpcd/acl.d/probe.json\n/usr/share/ucitrack/probe.json",
             "", "0", "0", ["rpcd reload", "ucitrack reload"]),
            ("offline", "/usr/share/rpcd/acl.d/probe.json\n/usr/share/ucitrack/probe.json",
             "/offline", "0", "0", []),
            ("fresh service", "/etc/init.d/probe", "", "0", "0",
             ["probe enable", "probe start", "ucitrack reload"]),
            ("disabled upgrade", "/etc/init.d/probe", "", "1", "0", ["ucitrack reload"]),
            ("enabled upgrade", "/etc/init.d/probe", "", "1", "1", ["probe start", "ucitrack reload"]),
        ]
        for name, files, root, upgrade, enabled, expected in cases:
            (work / "fixture.list").write_text(files + "\n", newline="\n")
            actual = bash(MOCKS + function + "\ndefault_postinst\n", work,
                          LISTDIR=directory, IPKG_INSTROOT=root, PKG_UPGRADE=upgrade, ENABLED=enabled)
            assert actual == expected, (fmt, name, actual, expected)
    (work / "fixture.list").write_text("/usr/share/ucitrack/probe.json\n")
    (work / "fixture.postinst").write_text("return 7\n")
    assert bash(MOCKS + function + "\ndefault_postinst\n", work, expected_status=7,
                LISTDIR="usr/lib/opkg/info", IPKG_INSTROOT="", HAS_POSTINST="1",
                PKG_UPGRADE="0", ENABLED="0") == ["ucitrack reload"]
    print("PASS: APK/opkg postinst routing, related reloads, offline isolation and service upgrade policy")

    fwtool = (work / PATHS[1]).read_text()
    condition = next(line.strip() for line in fwtool.splitlines()
                     if "if " in line and '"$SAVE_CONFIG"' in line)
    for imagecompat in ("1.0", "1.1"):
        for oem in ("", "board", "different-board"):
            for save in ("0", "1"):
                required = save == "1" and (imagecompat != "1.0" or oem == "board")
                actual = bash(condition + "\necho required\nelse\necho allowed\nfi\n", work,
                              devicecompat="1.0", imagecompat=imagecompat,
                              dev="board", oem=oem, SAVE_CONFIG=save)
                assert actual == ["required" if required else "allowed"], (imagecompat, oem, save, actual)
    print("PASS: actual fwtool condition in Bash: same/different compatibility, OEM/non-OEM, save 0/1")
