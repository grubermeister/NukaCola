global start

section .text
	bits 32

	error:
		mov dword [0xB8000], 0x4F524F45
		mov dword [0xB8004], 0x4F3A4F52
		mov dword [0xB8008], 0x4F204F20
		mov byte  [0xB800A], AL
		hlt
	check_multiboot:
		cmp EAX, 0x36D76289
		jne .no_multiboot
		ret
		.no_multiboot:
			mov AL, "0"
			jmp error
	check_cpuid:
		pushfd
		pop EAX
		mov ECX, EAX
		xor EAX, 1 << 21
		push EAX
		popfd
		pushfd
		pop EAX
		push ECX
		popfd
		cmp EAX, ECX
		je .no_cpuid
		ret
		.no_cpuid:
			mov AL, "1"
			jmp error
	check_long_mode:
		mov EAX, 0x80000000
		cpuid
		cmp EAX, 0x80000001
		jb .no_long_mode
		mov EAX, 0x80000001
		cpuid
		test EDX, 1 << 29
		jz .no_long_mode
		ret
		.no_long_mode:
			mov AL, "2"
			jmp error
	start:
		mov ESP, stack_top
		call check_multiboot
		call check_cpuid
		call check_long_mode
		mov dword [0xB8000], 0x2F4B2F4F
		hlt

section .bss
	stack_bottom:
		resb 64
	stack_top:
		
