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

  Label label1 = Label(10,10,5,RED);
  Label label2 = Label(10,45,4,RED);

//************************************************************************
//					Main Code
//************************************************************************
void	setup(){
  int	frameCounter;
  unsigned long	startTime;
  ioinit();
  Serial.begin(9600);

  LCDInit();			//Initialize the LCD
  
  pinMode(A0, INPUT);  
  LCDClear(BLACK);
  label1.set_value("Res: ");
}

//************************************************************************
//					Loop
//************************************************************************
void	loop(){
  int val = analogRead(A0);
  label2.set_value(val);
  refresh_screen(); 
  delay(500);
}
//************************************************************************

void refresh_screen(){
  LCDClear(BLACK);
  label1.print();
  label2.print();
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






