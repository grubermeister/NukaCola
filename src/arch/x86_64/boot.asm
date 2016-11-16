global start
extern long_mode_start

section .multiboot_header
	header_start:
		dd 0xE85250D6
		dd 0
		dd header_end - header_start
		dd 0x100000000 - (0xE85250D6+0+(header_end - header_start))

		dw 2
		dw 0
		dd 24
		dd header_start
		dd header_start
		dd load_end_addr
		dd stack_top

		dw 3
		dw 0
		dd 12
		dd start
		dd 0

		dw 0
		dw 0
		dd 8
	header_end:
		
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
	check_sse:
		mov EAX, 0x1
		cpuid
		test EDX, 1 << 25
		jz .no_sse
		ret
		.no_sse:
			mov AL, "a"
			jmp error
	setup_sse:
		mov EAX, CR0
		and AX,  0xFFFB
		or  AX,  0x2
		mov CR0, EAX
		mov EAX, CR4
		or  AX,  3 << 9
		mov CR4, EAX
		ret
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
	setup_page_tables:
		mov EAX, p3_table
		or  EAX, 0b11
		mov [p4_table], EAX
		mov EAX, p2_table
		or  EAX, 0b11
		mov [p3_table], EAX
		mov ECX, 0
		.map_p2_table:
			mov EAX, 0x200000
			mul ECX
			or  EAX, 0b10000011
			mov [p2_table + ECX * 8], EAX
			inc ECX
			cmp ECX, 512
			jne .map_p2_table
		ret
	enable_paging:
		mov EAX, p4_table
		mov CR3, EAX
		mov EAX, CR4
		or  EAX, 1 << 5
		mov CR4, EAX
		mov ECX, 0xC0000080
		rdmsr
		or  EAX, 1 << 8
		wrmsr
		mov EAX, CR0
		or  EAX, 1 << 31
		mov CR0, EAX
		ret
	start:
		cli
		mov ESP, stack_top
		mov EDI, EBX
		call check_multiboot
		call check_cpuid
		call check_sse
		call setup_sse
		call check_long_mode
		call setup_page_tables
		call enable_paging
		lgdt [gdt64.pointer]
		mov AX, gdt64.data
		jmp gdt64.code:long_mode_start
		hlt

section .rodata
	gdt64:
		dq 0
	.code: equ $ - gdt64
		dq (1 << 44) | (1 << 47) | (1 << 41) | (1 << 43) | (1 << 53)
	.data: equ $ - gdt64
		dq (1 << 44) | (1 << 47) | (1 << 41)
	.pointer:
		dw $ - gdt64 - 1
		dq gdt64
	load_end_addr:
		

section .bss
	align 4096

	p4_table:
		resb 4096
	p3_table:
		resb 4096
	p2_table:
		resb 4096
	stack_bottom:
		resb 8192
	stack_top:
		
