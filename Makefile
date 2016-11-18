arch ?= x86_64
kernel := build/kernel-$(arch).bin
iso := build/BigBootBaby.iso
target ?= $(arch)-pc-windows-msvc

linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, build/arch/$(arch)/%.o, $(assembly_source_files))
clang_source_files := $(wildcard src/*.c)
clang_object_files := $(patsubst src/%.c, build/debug/%.o, $(clang_source_files))

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

$(kernel): $(assembly_object_files) $(clang_object_files) $(linker_script)
	@ld -m i386pep -n -T $(linker_script) -o $(kernel) $(assembly_object_files) $(clang_object_files)

build/arch/$(arch)/%.o:  src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	@nasm -fwin64 $< -o $@

build/debug/%.o:  src/%.c
	@mkdir -p $(shell dirname $@)
	@clang -target $(target) -c $< -o $@ -I src/include -I /usr/include -ffreestanding -std=c99 -O2 -Wall -Wextra
