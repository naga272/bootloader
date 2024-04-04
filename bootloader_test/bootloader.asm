[org 0x7c00]

section .bss
section .data
section .text


_start: mov si, intro
	call print
	call main
	jmp $


%include "./kernel/gfunctions/print.asm"
%include "./kernel/gfunctions/string.asm"
%include "./kernel/gfunctions/comandi.asm"
%include "./kernel/main.asm"

%define endl 0x0d, 0x0a


intro: db "my first operative system!", endl, 0


times 510 - ($ - $$) db 0 
dw 0xaa55

