#ifndef INCLUDE_MULTIBOOT_H
#define INCLUDE_MULTIBOOT_H

typedef struct multiboot_info {
	uint32_t flags;
	uint32_t mem_lower;
	uint32_t mem_upper;
	uint32_t boot_device;
	uint32_t cmdline;
	uint32_t mod_count;
	uint32_t mod_list;
	uint32_t syms[4];
	uint32_t mmap_length;
	uint32_t mmap_addr;
} multiboot_info_t;

#endif
