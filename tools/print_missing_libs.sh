#!/bin/bash

#
# Print all missing libs of all ELF files under squashfs-root/
#
for x in $(./tools/find_elf.sh squashfs-root/ | grep -E -v "/bin/|/sbin/"); do
    ./tools/restricted_ldd.sh "$x"
done | grep "not " | sort -u

