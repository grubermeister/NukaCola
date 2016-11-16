#include "libk.h"
#include "serial.h"

void outb(unsigned char _data, unsigned short _port)
{
	__asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}

unsigned char inb(unsigned short _port)
{
	unsigned char rv;
	__asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
	return rv;
}

int serial_CheckFIFO(unsigned int com)
{
	return inb(SERIAL_LINE_STATUS_PORT(com)) & 0x20;
}


void kern_main()
{
	outb(0x00, SERIAL_COM1_BASE + 1);
	outb(0x80, SERIAL_COM1_BASE + 3);
	outb(0x03, SERIAL_COM1_BASE + 0);
	outb(0x00, SERIAL_COM1_BASE + 1);
	outb(0x03, SERIAL_COM1_BASE + 3);
	outb(0xC7, SERIAL_COM1_BASE + 2);
	outb(0x0B, SERIAL_COM1_BASE + 4);
	for(;;){
		while (serial_CheckFIFO(SERIAL_COM1_BASE) == 0);
		outb('!', SERIAL_COM1_BASE);
	}
}
