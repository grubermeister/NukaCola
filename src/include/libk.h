#ifndef INCLUDE_LIBK_H
#define INCLUDE_LIBK_H

#include <stdbool.h>
#include <stddef.h>

extern void _outb(unsigned char data, unsigned short port) __attribute__((ms_abi));
extern unsigned char _inb(unsigned short port) __attribute__((ms_abi));

#endif
