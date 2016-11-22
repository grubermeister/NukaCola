	.text
	.def	 kern_main;
	.scl	2;
	.type	32;
	.endef
	.globl	kern_main
	.align	16, 0x90
kern_main:                              # @kern_main
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	eax, 1016
	mov	dword ptr [rbp - 4], ecx
	mov	ecx, eax
	call	serial_Init
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	lea	rcx, qword ptr [rip + "??_C@_0P@MHJMLPNF@Hello?0?5World?$CB?6?$AA@"]
	call	kprintf
	jmp	.LBB0_1

	.section	.rdata,"rd",discard,"??_C@_0P@MHJMLPNF@Hello?0?5World?$CB?6?$AA@"
	.globl	"??_C@_0P@MHJMLPNF@Hello?0?5World?$CB?6?$AA@" # @"\01??_C@_0P@MHJMLPNF@Hello?0?5World?$CB?6?$AA@"
"??_C@_0P@MHJMLPNF@Hello?0?5World?$CB?6?$AA@":
	.asciz	"Hello, World!\n"


