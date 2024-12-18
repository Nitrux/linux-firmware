#! /bin/bash

set -x

### Basic Packages
apt -qq update
apt -qq -yy install equivs git devscripts lintian --no-install-recommends

### Remove these files and directories fomr upstream source.
files=(
    "*.asc" "*.asm" "*.c" "*.cmake" ".directory" "*.diff" "*.h" "*.py" "*.sh" "*.yaml" "*.yml"

    "*[Ll][Ii][Cc][Ee][Nn][Cc][Ee]*"
    "*Makefile*"
    "*[Nn][Oo][Tt][Ii][Cc][Ee]*.txt"
    "*WHENCE*"

    "lib/firmware/.codespell.cfg"
    "lib/firmware/.editorconfig"
    "lib/firmware/.gitignore"
    "lib/firmware/Apache-2"
    "lib/firmware/Dockerfile"
    "lib/firmware/GPL-2"
    "lib/firmware/GPL-3"
    "lib/firmware/README.md"
    "lib/firmware/amd-ucode/README"
    "lib/firmware/atusb/ChangeLog"
    "lib/firmware/brcm/brcmfmac43340-sdio.Insyde-VESPA2.txt"
    "lib/firmware/brcm/brcmfmac43362-sdio.ASUSTeK COMPUTER INC.-ME176C.txt"
    "lib/firmware/brcm/brcmfmac43430-sdio.ilife-S806.txt"
    "lib/firmware/brcm/brcmfmac4354-sdio.nvidia,p2371-2180.txt"
    "lib/firmware/contrib/templates/debian.changelog"
    "lib/firmware/contrib/templates/debian.control"
    "lib/firmware/contrib/templates/debian.copyright"
    "lib/firmware/contrib/templates/rpm.spec"
    "lib/firmware/isci/README"

    "*iwlwifi-*"
)


directories=(
    "lib/firmware/amd"
    "lib/firmware/amd-ucode"
    "lib/firmware/amdgpu"
    "lib/firmware/amdnpu"
    "lib/firmware/amdtee"
    "lib/firmware/ar3k"
    "lib/firmware/brcm"
    "lib/firmware/carl9170fw"
    "lib/firmware/cirrus"
    "lib/firmware/nvidia"
)

echo "Removing files..."
for file in "${files[@]}"; do
    find . -type f -name "$file" -exec rm -f {} +
done

echo "Removing directories..."
for dir in "${directories[@]}"; do
    rm -rf "$dir"
done

echo "Cleanup complete."

### Install Dependencies
mk-build-deps -i -t "apt-get --yes" -r

### Build Deb
debuild -b -uc -us

### Move Deb to current directory because debuild decided
### that it was a GREAT IDEA TO PUT THE FILE ONE LEVEL ABOVE
mv ../*.deb .
