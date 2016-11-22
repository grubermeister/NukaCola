#ifndef INCLUDE_LIBK_H
#define INCLUDE_LIBK_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <sys/cdefs.h>
#include <limits.h>
#include <stdarg.h>
#include "serial.h"
#include "multiboot.h"

#define is_digit(c)  ((c) >= '0' &&  (c) <= '9')

extern void _outb(unsigned char data, unsigned short port) __attribute__((ms_abi));
extern unsigned char _inb(unsigned short port) __attribute__((ms_abi));

size_t kstrlen(const char* str) __attribute__((ms_abi));
void kputchar(char c) __attribute__((ms_abi));
void kputs(const char* str, size_t len) __attribute__((ms_abi));

void panic(void) __attribute__((__noreturn__));

void i2a(int num, unsigned int base, char* bf) __attribute__((ms_abi));

void kprintf(const char* restrict format, ...) __attribute__((ms_abi));

int memcmp(const void* aptr, const void* bptr, size_t size) __attribute__((ms_abi));
void* memcpy(void* __restrict dstptr, const void* __restrict srcptr, size_t size) __attribute__((ms_abi));
void* memmove(void* dstptr, const void* srcptr, size_t size) __attribute__((ms_abi));
void* memset(void* bufptr, int value, size_t size) __attribute__((ms_abi));

void libtest(void) __attribute__((ms_abi));

#endif
