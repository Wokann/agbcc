#!/bin/sh
set -e
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXE=.exe ;;
    *) EXE= ;;
esac
if [ "$1" != "" ]; then
    mkdir -p "$1/tools/agbcc"
    mkdir -p "$1/tools/agbcc/bin"
    mkdir -p "$1/tools/agbcc/include"
    mkdir -p "$1/tools/agbcc/lib"
    cp "agbcc$EXE" "$1/tools/agbcc/bin/"
    cp "old_agbcc$EXE" "$1/tools/agbcc/bin/"
    cp "agbcc_arm$EXE" "$1/tools/agbcc/bin/"
    cp "agbcp$EXE" "$1/tools/agbcc/bin/"
    cp "agbcp_arm$EXE" "$1/tools/agbcc/bin/"
    cp -R libc/include "$1/tools/agbcc/" #drop include, because we don't want include/include
    cp ginclude/* "$1/tools/agbcc/include/"
    cp libgcc.a "$1/tools/agbcc/lib/"
    cp libc.a "$1/tools/agbcc/lib/"
else
    echo "Usage: install.sh PATH"
fi
