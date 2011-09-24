//************************************************************************
//					Nokia Shield
//************************************************************************
//*	Edit History
//*		<MLS>	= Mark Sproul msproul -at- jove.rutgers.edu
//************************************************************************
//*	Apr  2,	2010	<MLS> I received my Color LCD Shield sku: LCD-09363 from sparkfun
//*	Apr  2,	2010	<MLS> The code was written for WinAVR, I modified it to compile under Arduino
//*	Apr  3,	2010	<MLS> Changed LCDSetPixel to make it "RIGHT" side up
//************************************************************************

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>


#include	"WProgram.h"
#include	"HardwareSerial.h"


//************************************************************************
//					External Component Libs
//************************************************************************
#include "LCD_driver.h"
#include "nokia_tester.h"
#include "label.h"

#define	kSwitch1_PIN	3
#define	kSwitch2_PIN	4
#define	kSwitch3_PIN	5


//************************************************************************
//					Main Code
//************************************************************************
void	setup(){
  int	frameCounter;
  unsigned long	startTime;
  ioinit();
  Serial.begin(9600);
        
  LCDInit();			//Initialize the LCD
  
  LCDClear(BLACK);

  LCDPrintLogo();

}

//************************************************************************
//					Loop
//************************************************************************
void	loop()
{
        int	s1, s2, s3;

	s1	=	!digitalRead(kSwitch1_PIN);
	s2	=	!digitalRead(kSwitch2_PIN);
	s3	=	!digitalRead(kSwitch3_PIN);

        
	if (s1)
	{
		Serial.println("GRREN");
		LCDClear(GREEN);
		LCDPrintLogo();
	}
	else if (s2)
	{
		Serial.println("WHITE");
		LCDClear(WHITE);
		LCDPrintLogo();
	}
	else if (s3)
	{
	  LCDClear(WHITE);
          Label label1 = Label(50,50,3,RED);
          label1.set_value("012");
          label1.print();
	//	DisplayRGBimage();
		delay(5000);
	}
	delay(200);
}

//************************************************************************
void ioinit(void)
{


	//*	setup the switches for input
	pinMode(kSwitch1_PIN, INPUT);
	pinMode(kSwitch2_PIN, INPUT);
	pinMode(kSwitch3_PIN, INPUT);

	//*	set the pull up resisters
	digitalWrite(kSwitch1_PIN, HIGH);
	digitalWrite(kSwitch2_PIN, HIGH);
	digitalWrite(kSwitch3_PIN, HIGH);


	//*	do the LCD control lines
	pinMode(CS_PIN,			OUTPUT);
	pinMode(DIO_PIN,		OUTPUT);
	pinMode(SCK_PIN,		OUTPUT);
	pinMode(LCD_RES_PIN,	OUTPUT);

}

int	gWidth	=	ROW_LENGTH;
int	gHeight	=	COL_HEIGHT;

//*******************************************************************************
void	setPixel(int col, int row, RGBColor *rgbColor)
{
int color12bit;

	color12bit	=	(rgbColor->red << 4) & 0x0f00;
	color12bit	+=	(rgbColor->green) & 0x0f0;
	color12bit	+=	(rgbColor->blue >> 4) & 0x0f;
	
	LCDSetPixel(color12bit, col, row);
//	LCDSetPixel(color12bit, row, col);
}

//*******************************************************************************
boolean	gettouch()
{
int	s1, s2, s3;

	s1	=	!digitalRead(kSwitch1_PIN);
	s2	=	!digitalRead(kSwitch2_PIN);
	s3	=	!digitalRead(kSwitch3_PIN);

	return(s1 || s2 || s3);
}




//*******************************************************************************
void	DisplayRawRGB(uint8_t *rgbData, int xLoc, int yLoc)
{
int			imageWidth, imageHeight;
int			byte1, byte2;
long		dataIndex;
int			ii, jj;
RGBColor	myColor;
int			myXX, myYY;


	dataIndex	=	0;
	byte1		=	pgm_read_byte(rgbData + dataIndex++);
	byte2		=	pgm_read_byte(rgbData + dataIndex++);
	imageWidth	=	(byte1 << 8) + byte2;
	byte1		=	pgm_read_byte(rgbData + dataIndex++);
	byte2		=	pgm_read_byte(rgbData + dataIndex++);
	imageHeight	=	(byte1 << 8) + byte2;

	//*	if x,y are negitive, then center
	myXX	=	xLoc;
	myYY	=	yLoc;
	if (myXX < 0)
	{
		myXX	=	(gWidth - imageWidth) / 2;
	}
	if (myYY < 0)
	{
		myYY	=	(gHeight - imageHeight) / 2;
	}
	if (imageWidth < 100)
	{
		myXX	=	0;
		myYY	=	0;
	}
	for (jj=0; jj<imageHeight; jj++)
	{
		for (ii=0; ii<imageWidth; ii++)
		{
			myColor.green	=	pgm_read_byte(rgbData + dataIndex++);
			myColor.red		=	pgm_read_byte(rgbData + dataIndex++);
			myColor.blue	=	pgm_read_byte(rgbData + dataIndex++);
		
			if (imageWidth < 100)
			{
			short	doubleX, doubleY;
			
				doubleX	=	myXX + (2 * ii);
				doubleY	=	myYY + (2 * jj);
				setPixel(doubleX,		doubleY, &myColor);
				setPixel(doubleX + 1,	doubleY, &myColor);
			
				setPixel(doubleX,		doubleY + 1, &myColor);
				setPixel(doubleX + 1,	doubleY + 1, &myColor);

			}
			else
		
			{
				setPixel((myXX + ii), (myYY + jj), &myColor);
			}
		}
	}
}





