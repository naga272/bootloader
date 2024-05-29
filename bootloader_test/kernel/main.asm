; In a traditional design, it is responsible for memory management, I/O, interrupt handling, and various other things
; come collegare il kernel al bootloader
; https://stackoverflow.com/questions/21059483/loading-kernel-in-a-bootsector


%define ENDL 0x0d, 0x0a
%define EXIT_SUCCESS 0
%define EXIT_FAILURE 1
%define MAX_SIZE_SHELL_INPUT 256

section .bss
section .data
	input_usr db MAX_SIZE_SHELL_INPUT DUP(0); 255 char x linea input
section .text

;
;	CODICI CHIAMATA A 16 BIT
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
;
;	int 11h -> equipment check
;	int 12h -> memory size
;	int 13h -> Disk I/O
;		ah = 02h -> Read Sector from Drive
;
;	int 14h -> Serial Communication
;	int 15h -> Cassette
;	int 16h -> keyboard i/o
;


start_of_console db "Write something on the console", ENDL, 0 
english_keyboard db "English keyboard: activated", ENDL, 0
standby db ">>> ", 0
go_down db ENDL, 0


%macro MESSAGE_X_CONSOLE 1
	mov si, %1
	call print
%endmacro



%macro BACKSPACE_KEY 0
	cmp al, 8		; caso backspace
	je backspace
	jmp end_case_backspace
	backspace:	mov di, input_usr 	; vado a vettore[i - 1]
			cmp si, di
			je end_case_backspace
			dec si
	end_case_backspace:
%endmacro


main:	pusha

	MESSAGE_X_CONSOLE start_of_console
	MESSAGE_X_CONSOLE english_keyboard
	while_shell_open: 
		MESSAGE_X_CONSOLE standby
		mov si, input_usr

		user_input:
			mov ah, 00h
			int 16h

			BACKSPACE_KEY		; se viene premuto il tasto backspace allora devo decrementare si

			cmp al, 13		; se ha premuto invio allora significa che ha finito di scrivere il comando
			je out_user_input

			mov [si], al 
			call watch_what_write

			inc si
			jmp user_input

			ret
		out_user_input:
			MESSAGE_X_CONSOLE go_down

			mov si, input_usr
			call print	

			call clean_input
			MESSAGE_X_CONSOLE go_down
			jmp while_shell_open

	
	mov ax, EXIT_SUCCESS
	popa
	ret


watch_what_write: pusha

		  mov ah, 0eh
		  int 10h

		  popa
		  ret


clean_input: 	pusha
		
		mov ax, 0
		mov si, input_usr
		while_is_not_clean: cmp ax, MAX_SIZE_SHELL_INPUT
				    je end_clean_while
				    
                                    mov byte[si], 0
   
				    inc ax
				    inc si
				    jmp while_is_not_clean
		end_clean_while: popa
				 ret



; funzione con il compito di riconoscere e eseguire il comando difitato dall'utente
; ritorno EXIT_SUCCESS se e' andato tutto bene, 1 se qualcosa e' andato storto
msg_unknow_command db "Error! Unknow command", ENDL, 0
know_command:	push bp
		mov bp, sp

		;
		; e' x un comando consentito? se si lo eseguo, altrimenti do errore
		; funzioni consentite: exit -> consente di terminare il sistema operativo
		;
		push si
		call strncmp
		
		mov ax, EXIT_SUCCESS
		jmp go_out
		unknow_command:	mov si, msg_unknow_command
				call print
				mov ax, EXIT_FAILURE
		go_out:	leave
			ret
