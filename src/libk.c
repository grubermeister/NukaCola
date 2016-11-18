#include "libk.h"


void serial_Init(unsigned short com)
{
	_outb(0x00, SERIAL_DATA_PORT(com));
	_outb(0x80, SERIAL_LINE_COMMAND_PORT(com));
	_outb(0x03, SERIAL_PORT_BASE(com));
	_outb(0x00, SERIAL_DATA_PORT(com));
	_outb(0x03, SERIAL_LINE_COMMAND_PORT(com));
	_outb(0xC7, SERIAL_FIFO_COMMAND_PORT(com));
	_outb(0x0B, SERIAL_MODEM_COMMAND_PORT(com));
}

int serial_CheckFIFO(unsigned int com)
{
	return(_inb(SERIAL_LINE_STATUS_PORT(com)) & 0x20);
}

void kputchar(char c)
{
	while(serial_CheckFIFO(SERIAL_COM1) == 0);
	_outb(c, SERIAL_COM1);
}

size_t kstrlen(const char* str)
{

	size_t len = 0;

	while(str[len])
	{
		len++;
	}


	return(len);
}

void kputs(const char* str, size_t len)
{
	size_t i;
	const unsigned char* bytes = (const unsigned char*) str;

	for(i = 0; i < len; i++)
	{
		kputchar(bytes[i]);
	}
}

void kprintf(const char* str)
{
	kputs(str, kstrlen(*str));
}
