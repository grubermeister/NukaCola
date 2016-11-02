ENTRY(start)

SECTIONS {
	. = 1M;

	.boot :
	{
		/* ensure our multiboot header is at the beginning */
		*(.multiboot_header)
	}

	.text :
	{
		*(.text)
	}
}
