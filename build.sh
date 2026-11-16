#!/bin/sh
set -e
CC=${CC:-gcc}
CXX=${CXX:-g++}
export CC CXX
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) host=i686-pc-mingw32; EXE=.exe ;;
    *) host=i686-pc-linux; EXE= ;;
esac
make -C gcc clean
make -C gcc old CC="$CC" CXX="$CXX"
mv "gcc/old_agbcc$EXE" .
make -C gcc clean
make -C gcc CC="$CC" CXX="$CXX"
mv "gcc/agbcc$EXE" .
# not sure if the ARM compiler is the old one or the new one (-DOLD_COMPILER)
rm -f gcc_arm/config.status gcc_arm/config.cache
cd gcc_arm && ./configure --target=arm-elf --host="$host" && make clean && make cc1 && cd ..
mv "gcc_arm/cc1$EXE" "agbcc_arm$EXE"
# c++ compiler
rm -f g++/config.cache g++_arm/config.cache
cd g++ && ./configure --target=thumb-elf --disable-werror --with-cpu=arm7tdmi --with-no-thumb-interwork --disable-multilib --enable-languages="c++" --host="$host" --build="$host"
make clean && make "cc1plus$EXE" && cd ..
mv "g++/cc1plus$EXE" "agbcp$EXE"
cd g++_arm && ./configure --target=arm-elf --disable-werror --with-cpu=arm7tdmi --with-no-thumb-interwork --disable-multilib --enable-languages="c++" --host="$host" --build="$host"
make clean && make "cc1plus$EXE" && cd ..
mv "g++_arm/cc1plus$EXE" "agbcp_arm$EXE"
# runtime
make -C libgcc clean
make -C libgcc CC="$CC" CXX="$CXX"
mv libgcc/libgcc.a .
make -C libc clean
make -C libc CC="$CC" CXX="$CXX"
mv libc/libc.a .
