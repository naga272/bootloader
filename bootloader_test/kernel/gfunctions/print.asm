
;	int 10h -> for video:
;		ah = 00h -> set video mode
;		ah = 01h -> set cursor shape
;		ah = 02h -> set cursor position
;		ah = 03h -> set cursor position and shape
;		...
;		ah = 0eh -> Write character in TTY mode:
;			al, ASCII 
;			bh, page number (text modes)
;			bl, graphics mode


%define ENDL 0x0d, 0x0a


print:	pusha
	str_loop:
		mov al, [si]
		cmp al, 0
		je fine 
		mov ah, 0x0e
		int 10h
		add si, 1
		jmp str_loop
		
	fine:	popa
		ret
