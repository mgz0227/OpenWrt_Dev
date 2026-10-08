"""Run with GNU make/patch on PATH: python tests/test_kernel_apk_version.py.

MAKE and PATCH may point to binaries. Downloads the mixed tree's pinned sources.
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
KERNEL = "8208d1be0fba7425007df6f0de236c02b8a53bf8"
MAKE = os.environ.get("MAKE") or shutil.which("make")
PATCH = os.environ.get("PATCH") or shutil.which("patch")
assert MAKE and PATCH, "GNU make and patch are required (or set MAKE/PATCH)"
patches = [REPO / "devices/common/patches/imagebuilder.patch",
           REPO / "devices/x86_64/patches/kernel-apk-version.patch"]


def capture(pattern, text):
    match = re.search(pattern, text, re.M)
    assert match, pattern
    return match.group(1)


def consumers(root):
    full = (root / "package/Makefile").read_text()
    ib = (root / "target/imagebuilder/files/Makefile").read_text()
    return (capture(r'^\s*"kernel=(.*)"$', full),
            capture(r'^(BUILD_PACKAGES\+= \\\n(?:.*\n)*?)endif$', ib))


with tempfile.TemporaryDirectory(prefix="kernel-apk-version-") as temp:
    root = Path(temp)
    paths = {"include/kernel.mk", "package/kernel/linux/Makefile"}
    paths.update(line[6:] for patch in patches for line in patch.read_text().splitlines()
                 if line.startswith("+++ b/"))
    for path in sorted(paths):
        kernel = path.startswith(("include/", "package/kernel/")) or path == "scripts/target-metadata.pl"
        upstream, ref = ("graysky2/openwrt", KERNEL) if kernel else ("openwrt/openwrt", BASE)
        target = root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        with urlopen(f"https://raw.githubusercontent.com/{upstream}/{ref}/{path}", timeout=30) as response:
            target.write_bytes(response.read())
    before = consumers(root)
    for patch in patches:  # The workflow's alphabetical order for these files.
        mode = ["-B", "--merge"] if patch.name == "imagebuilder.patch" else ["--fuzz=0"]
        subprocess.run([PATCH, "--binary", "--batch", *mode, "-p1", "--forward"], cwd=root,
                       input=patch.read_bytes().replace(b"\r\n", b"\n"), check=True)
    assert not list(root.rglob("*.rej"))
    after = consumers(root)
    source = (root / "package/kernel/linux/Makefile").read_text()
    version = capture(r'^\s*VERSION:=(.*)$', source)
    raw = capture(r'^\s*echo (.*) > \$\(STAGING_DIR\)/kernel.version$', source)
    depends = capture(r'^\s*EXTRA_DEPENDS:=kernel \(=(.*)\)$',
                      (root / "include/kernel.mk").read_text())
    assert "$(LINUX_VERSION)" in raw and "subst" not in raw

    def expand(release, install, ib):
        script = f"""LINUX_VERSION:={release}
LINUX_RELEASE:=1
LINUX_VERMAGIC:=87c20a5de9abd833c8aad50d97f6b99c
STAGING_DIR:=.
KERNEL_VERSION:={raw}
$(file >kernel.version,$(KERNEL_VERSION))
{ib}
$(info package={version})
$(info dependency={depends})
$(info install={install})
$(info imagebuilder=$(BUILD_PACKAGES))
$(info release=$(LINUX_VERSION))
$(info raw=$(KERNEL_VERSION))
all:;
"""
        (root / "probe.mk").write_text(script)
        result = subprocess.run([MAKE, "-s", "-f", "probe.mk"], cwd=root,
                                text=True, capture_output=True, check=True)
        return dict(line.split("=", 1) for line in result.stdout.splitlines() if "=" in line)

    old = expand("7.3-rc6", *before)
    assert old["install"] != old["package"] and f'"kernel={old["package"]}"' not in old["imagebuilder"]
    for release in ("7.3-rc6", "7.3-rc10", "7.3", "6.12.50"):
        values = expand(release, *after)
        expected = release.replace("-rc", "_rc") + "~87c20a5de9abd833c8aad50d97f6b99c-r1"
        assert values["package"] == values["dependency"] == values["install"] == expected, values
        assert f'"kernel={expected}"' in values["imagebuilder"], values
        assert values["release"] == release and values["raw"].startswith(release + "~"), values
    print("PASS: old RC mismatch; full build and ImageBuilder pins match package/kmod metadata;")
    print("      RC6, RC10 and stable versions; raw kernel release preserved")

    # APK 3 prints ABI, section and CPE tags on the same line. Exercise the
    # actual ImageBuilder functions with both old and new package metadata.
    ib_source = (root / "target/imagebuilder/files/Makefile").read_text()
    definitions = "\n".join(capture(rf'^(define {name}\n[\s\S]*?^endef)', ib_source)
                            for name in ("GetABISuffix", "FormatPackages"))
    (root / "mock-apk.sh").write_text("cat tags.txt\n")
    for tags, package, expected in [
        ("Tags: openwrt:abiversion=4", "libcurl", "libcurl4"),
        ("Tags: openwrt:abiversion=4 openwrt:section=libs openwrt:cpe=cpe:/a:haxx:libcurl",
         "libcurl", "libcurl4"),
        ("Tags: openwrt:section=libs openwrt:abiversion=4", "libcurl=8.22.0-r1", "libcurl4=8.22.0-r1"),
        ("Tags: openwrt:section=libs\n  openwrt:abiversion=4", "libcurl", "libcurl4"),
        ("Tags: openwrt:section=utils", "curl", "curl"),
        ("Tags: openwrt:abiversion=4\nTags: openwrt:abiversion=5", "libcurl", "libcurl4"),
    ]:
        (root / "tags.txt").write_text(tags + "\n")
        (root / "probe.mk").write_text("APK:=sh mock-apk.sh\n" + definitions +
                                      f"\n$(info result=$(call FormatPackages,{package}))\nall:;\n")
        result = subprocess.run([MAKE, "-s", "-f", "probe.mk"], cwd=root,
                                text=True, capture_output=True, check=True)
        assert result.stdout.strip() == "result=" + expected, result
    print("PASS: ImageBuilder ABI extraction for old/new tags, wrapped lines and version pins")
