section .multiboot_header
header_start:
	dd 0xE85250D6
	dd 0
	dd header_end - header_start
	dd 0x100000000 - (0xE85250D6 + 0 + (header_end - header_start))

	dw 0
	dw 0
	dw 8
header_end:
	
