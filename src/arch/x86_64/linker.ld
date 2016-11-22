ENTRY(start)

SECTIONS {
	. = 1M;

	.text :
	{
		KEEP(*(.multiboot_header))
		*(.boot .boot.*)
		*(.text .text.*)
		. = ALIGN(4096);
	}

	.rodata :
	{
		*(.rodata .rodata.*)
		*(.rdata .rdata.*)
		. = ALIGN(4096);
	}

	.data :
	{
		*(.data .data.*)
		. = ALIGN(4096);
	}

	.bss :
	{
		*(COMMON)
		*(.bss .bss.*)
		. = ALIGN(4096);
	}
}
