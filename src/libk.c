#include "libk.h"
#include "serial.h"

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
	return _inb(SERIAL_LINE_STATUS_PORT(com)) & 0x20;
}

void kern_main()
{
	serial_Init(SERIAL_COM1);
	for(;;){
		while (serial_CheckFIFO(SERIAL_COM1) == 0);
		_outb('!', SERIAL_COM1);
	}
}
