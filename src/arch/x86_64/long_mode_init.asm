global long_mode_start

section .text
	bits 64

	long_mode_start:
		mov RAX, 0x2F4B2F4F
		mov qword [0xB8000], RAX
		hlt
