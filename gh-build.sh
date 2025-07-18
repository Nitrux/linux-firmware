#! /bin/bash

set -x

### Basic Packages
apt -qq update
apt -qq -yy install equivs git devscripts lintian --no-install-recommends

### Remove these files and directories from upstream source.
files=(
    "*.c"
    "*.cmake"
    "*.codespell.cfg"
    "*.diff"
    "*.editorconfig"
    "*.h"
    "*.py"
    "*.sh"
    "*.txt"
    "*.yaml"
    "*.yml"
    "*LICENCE*"
    "*LICENSE*"
    "*Makefile*"
    "*Notice*"
    "*WHENCE*"
    "*ar5523*"
    "*ar7010*"
    "*ar9170*"
    "*ar9271*"
    "*ath*"
    "*hfi1_*"
    "*htc_*"
    "*iwlwifi-*"
    "*rt2561*"
    "*rt2661*"
    "*rt2860*"
    "*rt2870*"
    "*rt3071*"
    "*rt3290*"
    "*rt73*"
    "*qat_*"
    "*wil6210*"
    ".directory"
    ".gitignore"
    "Apache-2"
    "ChangeLog"
    "Dockerfile"
    "GPL-2"
    "GPL-3"
    "README"
    "README.md"
)

directories=(
    "lib/firmware/amd"
    "lib/firmware/amd-ucode"
    "lib/firmware/amdgpu"
    "lib/firmware/amdnpu"
    "lib/firmware/amdtee"
    "lib/firmware/ar3k"
    "lib/firmware/ar3k"
    "lib/firmware/ath6k"
    "lib/firmware/ath9k_htc"
    "lib/firmware/ath10k"
    "lib/firmware/ath11k"
    "lib/firmware/ath12k"
    "lib/firmware/ath6k"
    "lib/firmware/brcm"
    "lib/firmware/carl9170fw"
    "lib/firmware/cirrus"
    "lib/firmware/e100"
    "lib/firmware/i915"
    "lib/firmware/intel"
    "lib/firmware/mediatek"
    "lib/firmware/nvidia"
    "lib/firmware/qca"
    "lib/firmware/r128"
    "lib/firmware/radeon"
    "lib/firmware/realtek"
    "lib/firmware/rtl_bt"
    "lib/firmware/rtl_nic"
    "lib/firmware/rtlwifi"
    "lib/firmware/rtw88"
    "lib/firmware/rtw89"
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
