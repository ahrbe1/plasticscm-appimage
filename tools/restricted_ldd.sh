#!/bin/bash

#
# run `ldd` with modified/restrictive LD_LIBRARY_PATH
#
ROOT="$(pwd)/squashfs-root"
LD_LIBRARY_PATH=$ROOT/usr/lib/x86_64-linux-gnu:$ROOT/opt/plasticscm5/mono/lib:$ROOT/opt/plasticscm5/client:$ROOT/lib/x86_64-linux-gnu ldd "$1" 2>/dev/null
