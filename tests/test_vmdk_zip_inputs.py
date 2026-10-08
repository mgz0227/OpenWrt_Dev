"""Run: python tests/test_vmdk_zip_inputs.py (Bash required; BASH overrides it).

Exercise shell expansion of the actual ZIP command with both BIOS and EFI
files present, without needing qemu-img or creating large disk images.
"""
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BASH = os.environ.get("BASH") or shutil.which("bash")
if not BASH and os.name == "nt":
    BASH = "C:/Program Files/Git/bin/bash.exe"
assert BASH, "Bash is required (or set BASH)"
patch = (ROOT / "devices/x86_64/patches/image-commands.patch").read_text()
match = re.search(r'^\+\t\tzip -jm (.*); \\$', patch, re.M)
assert match, "qemu-exsi ZIP command not found"
fixed_args = match.group(1).replace("$$", "$")
names = ["image-erofs-combined", "image-erofs-combined-efi"]

with tempfile.TemporaryDirectory(prefix="vmdk-zip-inputs-") as tmp:
    work = Path(tmp)
    for name in names:
        for suffix in [".vmdk", "-flat.vmdk"]:
            (work / (name + suffix)).touch()

    def inputs(args):
        script = "capture() {\nname=${1%.vmdk.zip}\nset -- " + args
        script += '\nprintf "%s\\n" "$@"\n}\n'
        script += "\n".join(
            f"capture {name}.vmdk.zip > {name}.args &" for name in names)
        script += "\nwait\n"
        subprocess.run([BASH, "-c", script], cwd=work, check=True)
        return [(work / (name + ".args")).read_text().splitlines() for name in names]

    old = inputs('$@ $name*.vmdk')
    assert len(old[0]) == 5, "old BIOS glob must reproduce cross-matching EFI files"
    fixed = inputs(fixed_args)
    for name, actual in zip(names, fixed):
        assert actual == [name + ".vmdk.zip", name + ".vmdk", name + "-flat.vmdk"], actual
    assert set(fixed[0][1:]).isdisjoint(fixed[1][1:])

print("PASS: old BIOS glob captures EFI files; fixed parallel ZIP inputs are disjoint")
