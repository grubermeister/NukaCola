arch ?= x86_64
kernel := build/kernel-$(arch).bin
iso := build/BigBootBaby.iso
target ?= $(arch)-pc-windows-msvc
libk := build/libk/$(target)/libk.a

linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, build/arch/$(arch)/%.o, $(assembly_source_files))

.PHONY:  all clean run iso

all:  $(kernel)

clean:
	@rm -r build

run:  $(iso)

iso:  $(iso)

$(iso):  $(kernel) $(grub_cfg)
	@mkdir -p build/isofiles/boot/grub
	@cp $(kernel) build/isofiles/boot/kernel.bin
	@cp $(grub_cfg) build/isofiles/boot/grub
	@grub-mkrescue -o $(iso) build/isofiles 2> /dev/null
	@rm -r build/isofiles

$(kernel):  $(libk) $(assembly_object_files) $(linker_script)
	@ld -m i386pep -n -T $(linker_script) -o $(kernel) $(assembly_object_files) $(libk)

build/arch/$(arch)/%.o:  src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	@nasm -fwin64 $< -o $@

$(libk):
	@mkdir -p build/libk/$(target)
	@clang -target $(target) -c src/libk.c -o $(libk) -I src/include/ -ffreestanding -O2 -Wall -Wextra
