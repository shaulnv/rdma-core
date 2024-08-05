#!/bin/bash

TEMP_INCLUDE_FOLDER=/tmp/my-include
INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX:-./out}

rm -rf $TEMP_INCLUDE_FOLDER
rm -rf build

mkdir -p $TEMP_INCLUDE_FOLDER
mkdir -p $TEMP_INCLUDE_FOLDER/x86_64-linux-gnu
ln -s /usr/include/linux $TEMP_INCLUDE_FOLDER/linux
ln -s /usr/include/asm-generic $TEMP_INCLUDE_FOLDER/asm-generic
ln -s /usr/include/x86_64-linux-gnu/asm $TEMP_INCLUDE_FOLDER/asm
# Create symbolic links for Python include directories
for dir in $(find /usr/include/x86_64-linux-gnu/python* -type d); do
  ln -s $dir $TEMP_INCLUDE_FOLDER/x86_64-linux-gnu/$(basename $dir | cut -d'-' -f2)
done
cmake -B build -GNinja -DCMAKE_C_COMPILER=musl-gcc -DCMAKE_C_FLAGS=-isystem$TEMP_INCLUDE_FOLDER -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DENABLE_STATIC=1
cmake --build build
cmake --install build
