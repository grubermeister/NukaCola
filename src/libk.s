	.text
	.def	 serial_Init;
	.scl	2;
	.type	32;
	.endef
	.globl	serial_Init
	.align	16, 0x90
serial_Init:                            # @serial_Init
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	ax, cx
	mov	word ptr [rbp - 2], ax
	movzx	ecx, word ptr [rbp - 2]
	inc	ecx
	mov	ax, cx
	movzx	edx, ax
	xor	ecx, ecx
	mov	dword ptr [rbp - 8], ecx # 4-byte Spill
	call	_outb
	movzx	ecx, word ptr [rbp - 2]
	add	ecx, 3
	mov	ax, cx
	movzx	edx, ax
	mov	ecx, 128
	call	_outb
	movzx	edx, word ptr [rbp - 2]
	mov	ecx, 3
	mov	dword ptr [rbp - 12], ecx # 4-byte Spill
	call	_outb
	movzx	ecx, word ptr [rbp - 2]
	inc	ecx
	mov	ax, cx
	movzx	edx, ax
	mov	ecx, dword ptr [rbp - 8] # 4-byte Reload
	call	_outb
	movzx	ecx, word ptr [rbp - 2]
	add	ecx, 3
	mov	ax, cx
	movzx	edx, ax
	mov	ecx, dword ptr [rbp - 12] # 4-byte Reload
	call	_outb
	movzx	ecx, word ptr [rbp - 2]
	add	ecx, 2
	mov	ax, cx
	movzx	edx, ax
	mov	ecx, 199
	call	_outb
	movzx	ecx, word ptr [rbp - 2]
	add	ecx, 4
	mov	ax, cx
	movzx	edx, ax
	mov	ecx, 11
	call	_outb
	add	rsp, 48
	pop	rbp
	ret

	.def	 serial_CheckFIFO;
	.scl	2;
	.type	32;
	.endef
	.globl	serial_CheckFIFO
	.align	16, 0x90
serial_CheckFIFO:                       # @serial_CheckFIFO
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	dword ptr [rbp - 4], ecx
	add	ecx, 5
	mov	ax, cx
	movzx	ecx, ax
	call	_inb
	movzx	ecx, al
	and	ecx, 32
	mov	eax, ecx
	add	rsp, 48
	pop	rbp
	ret

	.def	 kputchar;
	.scl	2;
	.type	32;
	.endef
	.globl	kputchar
	.align	16, 0x90
kputchar:                               # @kputchar
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	al, cl
	mov	byte ptr [rbp - 1], al
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	mov	ecx, 1016
	call	serial_CheckFIFO
	cmp	eax, 0
	jne	.LBB2_3
# BB#2:                                 #   in Loop: Header=BB2_1 Depth=1
	jmp	.LBB2_1
.LBB2_3:
	movzx	ecx, byte ptr [rbp - 1]
	mov	edx, 1016
	call	_outb
	add	rsp, 48
	pop	rbp
	ret

	.def	 kstrlen;
	.scl	2;
	.type	32;
	.endef
	.globl	kstrlen
	.align	16, 0x90
kstrlen:                                # @kstrlen
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	qword ptr [rbp - 8], rcx
	mov	qword ptr [rbp - 16], 0
.LBB3_1:                                # =>This Inner Loop Header: Depth=1
	mov	rax, qword ptr [rbp - 16]
	mov	rcx, qword ptr [rbp - 8]
	cmp	byte ptr [rcx + rax], 0
	je	.LBB3_3
# BB#2:                                 #   in Loop: Header=BB3_1 Depth=1
	mov	rax, qword ptr [rbp - 16]
	add	rax, 1
	mov	qword ptr [rbp - 16], rax
	jmp	.LBB3_1
.LBB3_3:
	mov	rax, qword ptr [rbp - 16]
	add	rsp, 16
	pop	rbp
	ret

	.def	 kputs;
	.scl	2;
	.type	32;
	.endef
	.globl	kputs
	.align	16, 0x90
kputs:                                  # @kputs
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 64
	mov	qword ptr [rbp - 8], rdx
	mov	qword ptr [rbp - 16], rcx
	mov	qword ptr [rbp - 24], 0
.LBB4_1:                                # =>This Inner Loop Header: Depth=1
	mov	rax, qword ptr [rbp - 24]
	cmp	rax, qword ptr [rbp - 8]
	jae	.LBB4_4
# BB#2:                                 #   in Loop: Header=BB4_1 Depth=1
	mov	rax, qword ptr [rbp - 24]
	mov	rcx, qword ptr [rbp - 16]
	movsx	ecx, byte ptr [rcx + rax]
	call	kputchar
# BB#3:                                 #   in Loop: Header=BB4_1 Depth=1
	mov	rax, qword ptr [rbp - 24]
	add	rax, 1
	mov	qword ptr [rbp - 24], rax
	jmp	.LBB4_1
.LBB4_4:
	add	rsp, 64
	pop	rbp
	ret

	.def	 kprintf;
	.scl	2;
	.type	32;
	.endef
	.globl	kprintf
	.align	16, 0x90
kprintf:                                # @kprintf
# BB#0:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	qword ptr [rbp - 8], rcx
	call	kstrlen
	mov	rcx, qword ptr [rbp - 8]
	mov	rdx, rax
	call	kputs
	add	rsp, 48
	pop	rbp
	ret


