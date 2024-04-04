#!/bin/bash

# compila codice assembly per il boot
nasm -f bin bootloader.asm -o bootloader.bin

# esegui il bootloader con qemu
qemu-system-x86_64 -hda ./bootloader.bin

# comandi per creare una ISO
truncate bootloader.bin -s 1200k
mkisofs -o os.iso -b bootloader.bin ./
