#include "libk.h"


void kern_main(uint32_t mboot_MemInfoAddr)
{
	serial_Init(SERIAL_COM1);
	for(;;)
	{
		if(kstrlen("TEST") > 0){
			kputchar('$');
		}else{
			kputchar('?');
		}
	}
}
