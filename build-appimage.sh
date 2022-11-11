#!/bin/bash
# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org/>

# **********************************************
# parse arguments
# **********************************************

set -euo pipefail

VERSION="1.2.0"

DO_PRUNE="n"     # n: no; y: yes
INSTALL_MODE="n" # n: neither; i: install; u: uninstall

requirements=(
    "basename"
    "docker"
    "fusermount"
    "sed"
    "grep"
    "cp"
    "mkdir"
    "ln"
    "rm"
    "ls"
)

for cmd in "${requirements[@]}"; do
    if ! command -v "$cmd" > /dev/null ; then
        echo "error: '$cmd' not found"
        exit 1
    fi
done

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--prune)
            DO_PRUNE="y"
            shift
            ;;
        -i|--install)
            INSTALL_MODE="i"
            shift
            ;;
        -u|--uninstall)
            INSTALL_MODE="u"
            shift
            ;;
        -v|--version)
            echo "version $VERSION"
            exit 1
            ;;
        -h|--help)
            echo "usage: $(basename $0) [-i|--install] [-u|--uninstall]"
            echo "         [-p|--prune] [-h|--help] [-v|--version]"
            echo
            echo "options:"
            echo "  -i|--install    install the application"
            echo "  -u|--uninstall  uninstall the application"
            echo "  -p|--prune      run 'docker image prune' after build"
            echo "  -h|--help       show this help text"
            echo "  -v|--version    show version information"
            echo
            exit 1
            ;;
        -*|--*)
            echo "error: unknown option '$1'"
            exit 1
            ;;
        *)
            echo "error: program takes no positional arguments"
            exit 1
            ;;
    esac
done

exit_status() {
    RET=$?
    if [ $RET -eq 0 ]; then
		echo "SUCCESS!"
	else
		echo "FAILED"
	fi
}

trap exit_status EXIT

# **********************************************
# build
# **********************************************

run() {
    echo $*
    eval "$(printf '%q ' "$@")"
    return $?
}

if [[ "$INSTALL_MODE" != "u" ]]; then
    run rm -rf out
    run mkdir -p out out/icons out/apps
    run docker build -t client:latest .

    CONTAINER_EXISTS="$(docker container ls -a | grep extract)" || RET=$?
    if [[ -n "$CONTAINER_EXISTS" ]]; then
        run docker rm -f extract
    fi

    run docker run --name extract --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined client:latest 
    run docker cp extract:/root/out/Plastic_SCM_Client.AppImage out/Plastic_SCM_Client.AppImage
    run docker cp extract:/root/build.log out/build.log
    run docker cp extract:/root/VERSION out/VERSION
    run docker cp extract:/root/SUFFIX out/SUFFIX
    run docker cp extract:/root/icons out/
    run docker cp extract:/root/apps out/
    run docker rm extract
    run mv out/Plastic_SCM_Client.AppImage out/Plastic_SCM_Client-$(cat out/VERSION)-$(cat out/SUFFIX).AppImage
    run ls -lh out/Plastic_SCM_Client-*.AppImage
fi

# **********************************************
# fix desktop files
# **********************************************
fix_desktop_file() {
    FPATH=$1
    echo "fix_desktop_file $FPATH"

    # redirect launcher to the AppImage
    run sed -i -e "s:/opt/plasticscm5/client/:$HOME/.local/bin/:" $FPATH

    # use absolute path for gtkmergetool
    run sed -i -e "s:Exec=gtkmergetool:Exec=$HOME/.local/bin/gtkmergetool:" $FPATH

    # fix icon paths
    run sed -i -e "s:/opt/plasticscm5/theme/gtk/:$HOME/.local/share/plasticscm/:" $FPATH

    # fix lingluonx -> gluon (existing bug in the *.desktop file)
    run sed -i -e "s:lingluonx:gluon:" $FPATH

    # set StartupNotify=false
    if ! grep -q StartupNotify $FPATH ; then
        run sed -i -e '/^Icon=.*/a StartupNotify=false' $FPATH
    fi
}

# **********************************************
# install
# **********************************************
if [[ "$INSTALL_MODE" = "i" ]]; then
    # check directories
    for DIR in $HOME/.local/share/applications $HOME/.local/opt $HOME/.local/bin $HOME/.local/share/plasticscm/icons
    do
        if [[ ! -d "$DIR" ]]; then
            run mkdir -p "$DIR"
        fi
    done

    APPIMAGE=$(ls -1 out/Plastic_SCM_Client-*.AppImage | xargs basename)

    # install appimage
    run cp out/$APPIMAGE $HOME/.local/opt/$APPIMAGE

    # install symlinks
    for CMD in cm gluon gtkmergetool plasticgui linplasticx
    do
        run ln -sf $HOME/.local/opt/$APPIMAGE $HOME/.local/bin/$CMD
    done

    # install icons
    for ICO in out/icons/*
    do
        ICO=$(basename $ICO)
        run cp out/icons/$ICO $HOME/.local/share/plasticscm/icons/$ICO
    done

    # install desktop files
    for APP in out/apps/*
    do
        APP=$(basename $APP)
        fix_desktop_file out/apps/$APP
        run cp out/apps/$APP $HOME/.local/share/applications/$APP
    done

    # check that ~/.local/bin is in $PATH
    if [[ ! ( ":$PATH:" == *":$HOME/.local/bin:"* ) ]]; then
        echo "warning: your $$PATH does not contain $HOME/.local/bin"
    fi
fi

# **********************************************
# uninstall
# **********************************************
if [[ "$INSTALL_MODE" = "u" ]]; then
    run rm -f $HOME/.local/share/applications/plasticx.desktop
    run rm -f $HOME/.local/share/applications/gluonx.desktop
    run rm -rf $HOME/.local/share/plasticscm
    run rm -f $HOME/.local/opt/Plastic_SCM_Client*.AppImage
    for CMD in cm gluon gtkmergetool gtkplastic legacygluon legacyplasticgui plasticgui linplasticx
    do
        run rm -f $HOME/.local/bin/$CMD
    done
fi

# **********************************************
# prune
# **********************************************
if [ "$DO_PRUNE" = "y" ]; then
    run docker image prune -f
fi

