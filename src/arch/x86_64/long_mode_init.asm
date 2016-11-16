global long_mode_start
extern kern_main

section .text
	bits 64

	long_mode_start:
		mov ECX, EDI
		call kern_main
		mov RAX, 0x2F4B2F4F
		mov qword [0xB8000], RAX
		hlt
