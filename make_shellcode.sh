#!/bin/bash

set -e 

if [ $# -ne 2 ]; then
    echo usage: $0 your_shellcode.asm 32/64 
    exit 1
fi


asm=$(realpath $1)
name=${asm%%.*}
echo "\n:::Shellcode Factory :::\n"


if [ $2 == '64' ]; then
	nasm -f elf64 $asm
	ld -m elf_x86_64 -o $name.out $name.o
elif [ $2 == '32' ]; then

	nasm -f elf32 $asm
	ld -m elf_i386 -o $name.out $name.o
else 
	echo "illigal arch"
	exit 
fi


echo -e "\n::: Your piece of art :::"
objdump -d -Mintel $name.out

objcopy -O binary $name.out $name.bin 

echo -e "\n::: done, look at $name.bin :::"
echo -n "::: length: "
wc -c $name.bin | cut -f1 -d' ' 
# Cleanup
rm -f $name.out $name.o
