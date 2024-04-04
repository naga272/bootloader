


; si -> str comando utente
strlen: pusha

	mov ax, 0
	head_strlen: 	cmp byte[si], 0
			je end_strlen
			inc ax
			inc si
			jmp head_strlen
	
	end_strlen:	popa
			ret



; si -> str comando
; di -> str comando utente
strncmp: pusha

	 mov ax, 0
	 while_not_end: cmp si, di
			jne not_equal

			cmp byte[si], 0
			je not_equal
			
			cmp byte[di], 0
			je not_equal

			inc si
			inc di
			jmp while_not_end

	 not_equal: mov ax, 1

	 end_strncmp: popa
	 	      ret

