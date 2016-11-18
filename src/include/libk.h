#ifndef INCLUDE_LIBK_H
#define INCLUDE_LIBK_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "serial.h"
#include "multiboot.h"

extern void _outb(unsigned char data, unsigned short port) __attribute__((ms_abi));
extern unsigned char _inb(unsigned short port) __attribute__((ms_abi));

size_t kstrlen(const char* str) __attribute__((ms_abi));
void kputchar(char c) __attribute__((ms_abi));
void kputs(const char* str, size_t len) __attribute__((ms_abi));
void kprintf(const char* str) __attribute__((ms_abi));

#endif
