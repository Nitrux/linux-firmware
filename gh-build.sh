#! /bin/bash

set -x

### Basic Packages
apt -qq update
apt -qq -yy install equivs git devscripts lintian --no-install-recommends

### Remove these files and directories from upstream source.
files=(
    "Apache-2"
    "Dockerfile"
    "GPL-2"
    "GPL-3"
    "README.md"
    "README"
    "ChangeLog"
    "*.c"
    "*.cmake"
    "*.codespell.cfg"
    "*.diff"
    "*.editorconfig"
    "*.h"
    "*.py"
    "*.sh"
    "*.yaml"
    "*.yml"
    ".directory"
    ".gitignore"
    "*Makefile*"
    "*LICENSE*"
    "*Notice*"
    "*WHENCE*"
    "*iwlwifi-*"
    "*wil62610*"
    "*htc_*"
    "*ar7010*"
    "*ar9170*"
    "*ar9271*"
    "*ar5523*"
)

directories=(
    "lib/firmware/amd"
    "lib/firmware/amd-ucode"
    "lib/firmware/amdgpu"
    "lib/firmware/amdnpu"
    "lib/firmware/amdtee"
    "lib/firmware/ar3k"
    "lib/firmware/ath10k"
    "lib/firmware/ath11k"
    "lib/firmware/ath12k"
    "lib/firmware/ath6k"
    "lib/firmware/brcm"
    "lib/firmware/carl9170fw"
    "lib/firmware/cirrus"
    "lib/firmware/i915"
    "lib/firmware/intel"
    "lib/firmware/nvidia"
    "lib/firmware/qca"
    "lib/firmware/r128"
    "lib/firmware/radeon"
    "lib/firmware/xe"
)

echo "Removing files..."
for file in "${files[@]}"; do
    find . -type f -name "$file" -exec rm -f {} \; 2>/dev/null
done

echo "Removing directories..."
for dir in "${directories[@]}"; do
    rm -rf "$dir" 2>/dev/null
done

echo "Cleanup complete."

### Install Dependencies
mk-build-deps -i -t "apt-get --yes" -r

### Build Deb
debuild -b -uc -us

### Move Deb to current directory because debuild decided
### that it was a GREAT IDEA TO PUT THE FILE ONE LEVEL ABOVE
mv ../*.deb .
