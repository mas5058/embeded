/*
 * nodatacache.c
 *
 *  Created on: Apr 22, 2018
 *      Author: jxciee
 */

#include "system.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

uint32* switches = (uint32*)(SWITCHES_BASE);
uint32* leds = (uint32*)(LEDS_BASE);

int main(void)
{
	uint32 sw_value = 0;
	while (1)
	{
			sw_value = *(switches);
			*(leds) = sw_value;

	}
}

