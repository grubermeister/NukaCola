ENTRY(start)

SECTIONS {
	. = 1M;

	.text :
	{
		KEEP(*(.multiboot_header))
		*(.text .text.*)
		*(.rodata .rodata.*)
		. = ALIGN(4096);
	}

	.bss :
	{
		*(.bss .bss.*)
		. = ALIGN(4096);
	}
}
