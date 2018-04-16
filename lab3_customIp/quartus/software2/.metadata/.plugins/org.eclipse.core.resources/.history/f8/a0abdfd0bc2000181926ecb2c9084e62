#include "system.h"
#include <stdbool.h>

//typedef enum {false, true} bool;
	unsigned long *ledPtr= (unsigned long *) PIO_0_BASE;
	unsigned long *keyptr = (unsigned long *) PIO_1_BASE;
	//unsigned short *ledsBase_ptr = (unsigned short *) LEDS_BASE;
	unsigned long *addr = (unsigned long *) 0;
	/* unsigned long *addr1;
	unsigned long *addr2;
	unsigned long *addr3; */
	unsigned long ledVal;
	unsigned long keyVal;
	unsigned short count = 0;

void main()
{
	while (1){
		keyVal = *keyptr;
		;
		while((keyVal) == 0){
			keyVal = *keyptr;
		}
		while((keyVal) == 1){
			while (count < 1){
				ledVal = 0;
				// addr1 = 0x1248a3b7;
				// addr2 = 0x1249a4b8;
				// addr3 = 0x144aa5b9;
				if (ramConfidenceTest(addr1, 0x1248a3b7) && ramConfidenceTest(addr2, 0x1249a4b8) && ramConfidenceTest(addr3, 0x144aa5b9) == true){
					ledVal = 11111111;
				}
				else{
					ledVal = 0;
				}
				count++;
			}
			ledPtr = ledVal;
			count = 0;

		}

	}
}

bool ramConfidenceTest(unsigned long *ptr, numBytesToCheck){
 //for loop that iterates though addresses and checks them (num bytes = the amount of bytes being checked)
	if(ptr == numBytesToCheck){
		return true;
	}
	else{
		return false;
	}
}

void writeData(int times){
	int i = 0;
	//unsigned long addr = 0
	while (times > i){
		*addr = i;
		i++ 
		addr++
	}
}
