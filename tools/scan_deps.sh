#!/bin/bash

set -euo pipefail

declare -A seen

scan_deps() {
    local -r path="$1"
    echo "scan: $path"
    for line in $(./tools/restricted_ldd.sh "$path" | sed -e 's/^\s*//' | grep "=" | cut -f1,3 -d' ' | sed -e 's/ /,/'); do
        lib=$(echo "$line" | cut -f1 -d,)
        found=$(echo "$line" | cut -f2 -d,)
        if [ "$found" = "not" ]; then
            echo "  missing: $lib"
        elif [ ! -v 'seen[$lib]' ] ; then
            seen["$lib"]="y"
            if [[ "$found" =~ squashfs-root/* ]]; then
                scan_deps "$found"
            else
                echo "  outside AppImage: $found"
            fi
        fi
    done
}

for x in $(./tools/find_elf.sh squashfs-root/ | grep -E -v "/bin/|/sbin/"); do
    scan_deps "$x"
done

