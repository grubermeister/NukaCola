#include "libk.h"

void kern_main(uint32_t mboot_MemInfoAddr)
{
	/*char* str = NULL;
	i2a(i, 10, str);
	size_t len = kstrlen(str);*/

	serial_Init(SERIAL_COM1);
	for(;;)
	{
		libtest();
		//kprintf("%d ", 69);
		//kputs(str, len);
	}
}
