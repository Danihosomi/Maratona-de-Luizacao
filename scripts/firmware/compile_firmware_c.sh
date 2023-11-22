#!/bin/bash -eu

export TARGET=$1
export TARGET_FILENAME=$(basename ${TARGET})

echo $TARGET_FILENAME

riscv64-unknown-elf-gcc -g -march=rv32i -std=gnu99 -mabi=ilp32 firmware/${TARGET} -o temp/${TARGET_FILENAME}.riscv -g -march=rv32i -std=gnu99 -mabi=ilp32 -nostartfiles -nostdinc -Ttext=4 -Tdata=200 -ffunction-sections;
riscv64-unknown-elf-objdump -d temp/${TARGET_FILENAME}.riscv  > temp/${TARGET_FILENAME}.dump;
elf2hex 4 256 temp/${TARGET_FILENAME}.riscv > rom.hex;