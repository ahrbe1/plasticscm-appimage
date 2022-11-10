#!/bin/bash

#
# Print paths to all ELF files under directory $1
#
for x in $(find "$1" -type f); do
    file "$x" | grep ELF > /dev/null
    is_elf=$?
    if [ $is_elf -eq 0 ]; then
        echo "$x"
    fi
done
