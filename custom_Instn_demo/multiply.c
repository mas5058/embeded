//*****************************************************************************
//***************************  VHDL Source Code  ******************************
//*********  Copyright 2012, Rochester Institute of Technology  ***************
//*****************************************************************************
//
//      NAME: Program Controlled Input/Output: NIOS-II based
//
//  FILENAME: multiply.c
//
//   CREATED:  10/11/2012
//
// ============================================================================
//
//   DESCRIPTION:
//    The following program performs a simple multiply operation in C. The 
//    numbers to be multiplied by itself will be read from the input pio connected to 
//    the switches on the DE1 board.  The product will be returned to the PIO
//    connected to the red LEDs on the DE1 board.
//    The program makes use of the HAL timestamp functions to measure the amount of
//    time the execution of multiplication takes
/
//
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
//                    Include Files
//*****************************************************************************
#include <sys/alt_timestamp.h>      // for timestamp functions
#include "stdio.h"                  // for printf (need %f support)
#include "system.h"                 // for QSYS parameters


//*****************************************************************************
//                  Define symbolic constants
//*****************************************************************************

#define MAX_OVERHEAD_LOOP_CNT     10


// create standard embedded type definitions
typedef   signed char   sint8;        // signed 8 bit values
typedef unsigned char   uint8;        // unsigned 8 bit values
typedef   signed short  sint16;       // signed 16 bit values
typedef unsigned short  uint16;       // unsigned 16 bit values
typedef   signed long   sint32;       // signed 32 bit values
typedef unsigned long   uint32;       // unsigned 32 bit values
typedef         float   real32;       // 32 bit real values


//*****************************************************************************
//                     Define private data
//*****************************************************************************


uint32* switchPtr = (uint32*)SWITCHES_BASE;
uint32* redLedPtr = (uint32*)LEDR_BASE;


//*****************************************************************************
//                     Define private functions
//*****************************************************************************


//*****************************************************************************
// NAME: Convert System Tick to mSeconds
//
// DESCRIPTION:
//    The function will convert the system tick into mSeconds.
//
// INPUTS:
//    ticks - system ticks to convert to mSeconds
// OUTPUTS:
//    none
// RETURN:
//    returns time of ticks in mSeconds
//*****************************************************************************
real32 ConvertTicksTo_mSec(uint32 ticks)
{
  return (float) 1000000 * (float) ticks / (float) alt_timestamp_freq();
} /* ConvertTicksTo_mSec */


//*****************************************************************************
// NAME: Get Starting Timestamp Timer
//
// DESCRIPTION:
//    This function will start the timestamp timer and read the current 
//    timestamp to get the current system tick value.
//
// INPUTS:
//    none
// OUTPUTS:
//    none
// RETURN:
//    return current timestamp
//*****************************************************************************
uint32 GetStartTimestamp(void)
{
  // The alt_timestamp_start() function resets the timestamp counter to 
  // zero, and starts the counter running.
  alt_timestamp_start();
  
  return ( alt_timestamp() );
  
} /* GetStartTimestamp */


//*****************************************************************************
// NAME: Get Ending Timestamp
//
// DESCRIPTION:
//    This function stops the clock for a timing measurement.
//
// INPUTS:
//    none
// OUTPUTS:
//    none
// RETURN:
//    return current timestamp
//*****************************************************************************
uint32 GetEndTimestamp(void)
{
  return (alt_timestamp());
} /* GetEndTimestamp */



//*****************************************************************************
//                     Define public functions
//*****************************************************************************



//*****************************************************************************
//                              MAIN
//*****************************************************************************
int main(void)
{

  int i = 0;
  uint32 op1  = 0;
  //uint32 op2  = 0;
  uint32 prod = 0;
  uint32 switch_value   = 0;
  uint32 elapsed_time   = 0;
  uint32 start_time     = 0;
  uint32 stop_time      = 0;
  uint32 timer_overhead = 0;


  printf("ESD-II Custom Instruction Program Running\n");

  // -----------------------------------------------------------------------
  // To determine the amount of overhead in makeing the timestamp calls
  // we will make several calls to timestamp to measure average overhead
  // -----------------------------------------------------------------------
  for (i = 0; i < MAX_OVERHEAD_LOOP_CNT; i++) 
  {      
    start_time = GetStartTimestamp();
    stop_time  = GetEndTimestamp();
    timer_overhead = timer_overhead + (stop_time - start_time);
  } /* for i */
  
  // calculate the average
  timer_overhead = timer_overhead / MAX_OVERHEAD_LOOP_CNT;

  // read the switches
  switch_value = *switchPtr;
  
  // extract the operands from the switch settings
  op1 = (switch_value & 0x000000FF);
  //op2 = (switch_value & 0x0000FF00) >> 8;
     
  start_time = GetStartTimestamp();

  // perform software product calculation
  prod = op1 * op1;
  
  stop_time = GetEndTimestamp();

  // perform custom instruction product calculation

  // send product to red leds
  *redLedPtr = prod;

      
  elapsed_time = stop_time - start_time - timer_overhead;

  printf("%03d x %03d = %5d \n", (int)op1, (int)op1, (int)prod);
  printf("total time = (%5.2f us)\n",ConvertTicksTo_mSec(elapsed_time));

  return 0;

} /* main */
