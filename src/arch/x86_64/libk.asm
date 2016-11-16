global _outb
global _inb

section .text
	bits 64

	_outb:
		push  RBP
		mov   RBP, RSP
		push  RAX
		mov   AX, DX
		mov   R8B, CL
		mov   word [RBP-2], AX
		mov   byte [RBP-3], R8B
		movzx ECX, word [RBP-2]
		mov   AX, CX
		mov   DX, AX
		mov   AL, R8B
		out   DX, AL
		add   RSP, 8
		pop   RBP
		ret

	_inb:
		push  RBP
		mov   RBP, RSP
		push  RAX
		mov   AX, CX
		mov   word [RBP-2], AX
		mov   DX, AX
		in    AL, DX
		mov   byte [RBP-3], AL
		movzx EAX, byte [RBP-3]
		add   RSP, 8
		pop   RBP
		ret
