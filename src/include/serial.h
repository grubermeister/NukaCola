#ifndef INCLUDE_SERIAL_H
#define INCLUDE_SERIAL_H

#define SERIAL_COM1			0x3F8

#define SERIAL_PORT_BASE(base)		(base)
#define SERIAL_DATA_PORT(base)	        (base + 1)
#define SERIAL_FIFO_COMMAND_PORT(base)	(base + 2)
#define SERIAL_LINE_COMMAND_PORT(base)	(base + 3)
#define SERIAL_MODEM_COMMAND_PORT(base)	(base + 4)
#define SERIAL_LINE_STATUS_PORT(base)	(base + 5)

#define SERIAL_LINE_ENABLE_DLAB	0x80

void serial_Init(unsigned short com) __attribute__((ms_abi));
int  serial_CheckFIFO(unsigned int com) __attribute__((ms_abi));

#endif
