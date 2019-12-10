/*
 * MicroBlaze_c_code.c
 *
 *  Created on: Dec 8, 2019
 *      Author: kaleb
 */


#include "xparameters.h"
#include "xbasic_types.h"
#include "xgpio.h"
#include "xstatus.h"

//declare an XGpio instance
XGpio GpioDevice;

int main (void) {

	// Define variables
	Xuint32 status;
	Xuint32 DataRead;
	Xuint32 OldData;
	Xuint32 numA;
	Xuint32 numB;
    //ADDITIONAL OPERATION VARIABLE FOR ALU OP SELECT
    Xuint32 op;

	xil_printf("Hello...\r\n");

	// Initialize the GPIO driver
	status = XGpio_Initialize(&GpioDevice,XPAR_GPIO_0_DEVICE_ID);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	// Set the direction for all signals in channel 1 to be outputs (UPDATED 16 PLACES)
	XGpio_SetDataDirection(&GpioDevice, 1, 0x0000000000000000);
	// Set the direction for all signals in channel 2 to be inputs  (UPDATED 22 PLACES)
	XGpio_SetDataDirection(&GpioDevice, 2, 0xFFFFFFFFFFFFFFFFFFFFFF);

	OldData = 0xFFFFFFFFFFFFFFFFFFFFFF;
	while(1){
		// Read the state of the DIP switches
		DataRead = XGpio_DiscreteRead(&GpioDevice, 2);

		// Bit Masking and bitwise operations to separate the data into two numbers
		numA = DataRead & 0x3F000;      //INPUT BITS [21:12] (COUNT_OUT)
        numA = numA >> 12;              //GET 10-BIT RESULT

		numB = DataRead & 0xFFC;        //INPUT BITS [11:1] (PRE_VAL)
		numB = numB >> 2;               //GET 10-BIT RESULT

        op = DataRead & 0x3;            //INPUT BITS [1:0] (ALU OPERATION SELECT)

		// Send the data to the UART if the settings change
		if(DataRead != OldData){

            //SWITCH OUTPUT BASED ON OP INPUT

            xil_printf("Num A = %d\r\n", numA);
			xil_printf("Num B = %d\r\n", numB);

            switch(op)
            {
                case 0 :    //ADD
			        xil_printf("Num A + Num B => %d + %d = %d\r\n",numA, numB, numA+numB);
                    xil_printf("-------------------------------------------------\r\n");

                    if(numA+numB > 65535)
                    {
                        xil_printf("Result is greater than 16 bits. LED output may be incorrect\n");
                        xil_printf("due to bit width limitations.\n\n");
                    }

                    break;

                case 1 :    //SUBTRACT
			        xil_printf("Num A - Num B => %d - %d = %d\r\n",numA, numB, numA-numB);
                    xil_printf("-------------------------------------------------\r\n");

                    if(numA-numB > 65535)
                    {
                        xil_printf("Result is greater than 16 bits. LED output may be incorrect\n");
                        xil_printf("due to bit width limitations.\n\n");
                    }

                    break;

                case 2 :    //MULTIPLY
			        xil_printf("Num A * Num B => %d * %d = %d\r\n",numA, numB, numA*numB);
			        xil_printf("-------------------------------------------------\r\n");

                    if(numA*numB > 65535)
                    {
                        xil_printf("Result is greater than 16 bits. LED output may be incorrect\n");
                        xil_printf("due to bit width limitations.\n\n");
                    }

                    break;

                case 3 :    //DIVIDE
                   xil_printf("Num A / Num B => %d / %d = %d\r\n",numA, numB, numA/numB);
                   xil_printf("-------------------------------------------------\r\n");

                   if(numA/numB > 65535)
                    {
                        xil_printf("Result is greater than 16 bits. LED output may be incorrect\n");
                        xil_printf("due to bit width limitations.\n\n");
                    }

                   break;
            }

            // Set the GPIO outputs to the switch values
			XGpio_DiscreteWrite(&GpioDevice, 1, DataRead);
			// Save the DIP switch settings
			OldData = DataRead;
		}
	}

  return 0;
}
