global _outb
global _inb
global _write

section .text
	bits 64

	_outb:
		mov RDX, RCX
		mov RAX, RDX
		out DX, AL
		ret

	_inb:
		mov RDX, RCX
		in  AL, DX
		ret
