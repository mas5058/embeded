#include "system.h"
typedef enum {false = 0, true = 1} bool;

	unsigned long *ledPtr= (unsigned long *) LEDS_BASE;
	unsigned long *keyptr = (unsigned long *) KEY1_BASE;
	//unsigned short *ledsBase_ptr = (unsigned short *) LEDS_BASE;
	unsigned char *addr = (unsigned long *) 0;
	/* unsigned long *addr1;
	unsigned long *addr2;
	unsigned long *addr3; */
	unsigned long ledVal = 0;
	unsigned long keyVal;
	unsigned short count = 0;

void main()
{
	writeData(4);
	*ledPtr = ledVal;
	addr = 0;
	while (1){
		keyVal = *keyptr;


		while((keyVal) == 1){
			keyVal = *keyptr;
		}
		while((keyVal) == 0){
			while (count < 1){
				ledVal = 0;

				if (ramTestByte(addr, 4) == 1){
					ledVal = 255;
				}
				else{
					ledVal = 0;
				}
				count++;
			}
			keyVal = *keyptr;
			*ledPtr = ledVal;
			count = 0;
		}

	}
}


int ramConfidenceTest(unsigned long *ptr, int numBytesToCheck){
 //for loop that iterates though addresses and checks them (num bytes = the amount of bytes being checked)
	int i = 0;
	//int c = 0;
	bool b = 1;
	while(i < numBytesToCheck){
		if (*ptr == i){
			i++;
			ptr++;
			continue;
		}
		else{
			b = 0;
			break;
		}
	}
	return b;
}


void writeData(int times){
	int i = 0;
	while (times > i){
		*addr = i;
		i++;
		addr++;
		//times--;
	}
}

int ramTestByte(char *ptr, int numBytesToCheck){
	int i = 0;
	bool b = true;
	while(i < numBytesToCheck){
		if(*ptr == i){
			i++;
			ptr++;
			continue;
		}
		else{
			b = false;
			break;
		}
	return b;
	}
}

int ramTestHalfwork(unsigned short *ptr, int numBytesToCheck){
	int i = 0;
		int b = true;
		while(i < numBytesToCheck){
			if(*ptr== i){
				i++;
				ptr++;
				continue;
			}
			else{
				b = false;
				break;
			}
		return b;
	}
}


