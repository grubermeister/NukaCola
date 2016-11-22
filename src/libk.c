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
	if(c == '\n')
	{
		_outb('\r', SERIAL_COM1);
	}
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

	for(i = 0; i < len; i++)
	{
		kputchar(str[i]);
	}
}

void panic(void)
{
	const char* abort = "kernel:  calling abort()\n";

	kputs(abort, kstrlen(abort));
	while(1){}
	__builtin_unreachable();
}

int memcmp(const void* aptr, const void* bptr, size_t size)
{
	const unsigned char* a = (const unsigned char*) aptr;
	const unsigned char* b = (const unsigned char*) bptr;

	for(size_t i = 0; i < size; i++)
	{
		if(a[i] < b[i])
		{
			return(-1);
		}
		else if(b[i] < a[i])
		{
			return(1);
		}
	}

	return(0);
}

void* memcpy(void* restrict dstptr, const void* restrict srcptr, size_t size)
{
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;

	for(size_t i = 0; i < size; i++)
	{
		dst[i] = src[i];
	}

	return(dstptr);
}

void* memmove(void* dstptr, const void* srcptr, size_t size)
{
	unsigned char* dst = (unsigned char*) dstptr;
	const unsigned char* src = (const unsigned char*) srcptr;

	if(dst < src)
	{
		for(size_t i = 0; i < size; i++)
		{
			dst[i] = src[i];
		}
	}
	else
	{
		for(size_t i = size; i != 0; i--)
		{
			dst[i-1] = src[i-1];
		}
	}

	return(dstptr);
}

void* memset(void* bufptr, int value, size_t size)
{
	unsigned char* buf = (unsigned char*) bufptr;

	for(size_t i = 0; i < size; i++)
	{
		buf[i] = (unsigned char) value;
	}

	return(bufptr);
}

void i2a(int num, unsigned int base, char* bf)
{
	int n = 0;
	unsigned int d = 1;

	while(num / d >= base)
	{
		d *= base;
	}
	while(d != 0)
	{
		int digit = num / d;

		num %= d;
		d /= base;
		if(n || digit > 0 || d == 0)
		{
			*bf++ = digit + (digit < 10 ? '0' : 'a' - 10);
			++n;
		}
	}
	*bf = 0;
}

void kprintf(const char* restrict format, ...)
{
	va_list params;
	int written = 0;

	va_start(params, format);
	while(*format != '\0')
	{
		size_t maxrem = INT_MAX - written;

		if(format[0] != '%' || format[1] == '%')
		{
			if(format[0] == '%')
			{
				format++;
			}
			size_t amount = 1;
			while(format[amount] && format[amount] != '%')
			{
				amount++;
			}
			if(maxrem < amount)
			{
				panic();
			}
			kputs(format, amount);
			format += amount;
			written += amount;
			continue;
		}

		const char* format_start = format++;

		if(*format == 'c')
		{
			format++;
			char c = (char) va_arg(params, int);
			if(!maxrem)
			{
				panic();
			}
			kputs(&c, sizeof(c));
			written++;
		}
		else if(*format == 's')
		{
			format++;
			const char* str = va_arg(params, const char*);
			size_t len = kstrlen(str);
			if(maxrem < len)
			{
				panic();
			}
			kputs(str, len);
			written += len;
		}
		else if(*format == 'd')
		{
			format++;
			int i = va_arg(params, int);
			char str[16];
			i2a(i, 10, str);
			size_t len = kstrlen(str);
			if(!maxrem)
			{
				panic();
			}
			kputs(str, len);
			written += len;
		}
		else
		{
			format = format_start;
			size_t len = kstrlen(format);
			if(maxrem < len)
			{
				panic();
			}
			kputs(format, len);
			written += len;
			format += len;
		}
	}

	va_end(params);
}

void libtest(void)
{
	char str[512];

	i2a(420, 10, str);
	kputs(str, kstrlen(str));
}
