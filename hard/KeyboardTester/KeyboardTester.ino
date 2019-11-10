/*


Распиновка подключения к ATMEG2560
		 -------                                                          -------
		| POWER |                                                        |  USB  |
	  -----------------------------------------------------------------------------------------
	 |                                                                                         |---
	 |                                                                                    AREF |   |
	 |                                                                                     GND |   |
	 |                                                                                      13 |   |
  ---|                                                                                      12 |   |
 |   | RST                                                                                  11 |   |
 |   | 3V                                                                                   10 |   |
 |   | 5V                                                                                    9 |   |
 |   | GND                                                                                   8 |   |
 |   |                                                                                         |---
 |   | VIN                                                                                   7 |   |
  ---|                                                                                       6 |   |
 |   | A0                                                                                    5 |   |
 |   | A1                                                                                    4 |   |
 |   | A2                                                                                    3 |   |
 |   | A3                                                                                    2 |   |
 |   | A4                                                                                    1 |   |
 |   | A5                                                                                    0 |   |
 |   | A6                                                                                      |---
 |   | A7                                                                                   14 |   |
  ---|                                                                                      15 |   |
 |   | A8                                                                                   16 |   |
 |   | A9                                                                                   17 |   |
 |   | A10                                                                                  18 |   |
 |   | A11                                                                                  19 |   |
 |   | A12                                                                                  20 |   |
 |   | A13                                                                                  21 |   |
 |   | A14                                                                                     |---
 |   | A15                                                                                     |
  ---|      SCK MISO                                                                           |
	 | GND| 52 | 50 | 48 | 46 | 44 | 42 | 40 | 38 | 36 | 34 | 32 | 30 | 28 | 26 | 24 | 22 | +5V|
	  -----------------------------------------------------------------------------------------
	 | XX |    |    | C1 | C3 | C5 | C7 |    |    | B1 | B3 | B5 | B7 | A6 | A4 | A2 | A0 | XX |
	 | XX |    |    | C0 | C2 | C4 | C6 |    |    | B0 | B2 | B4 | B6 | A7 | A5 | A3 | A1 | XX |
	  -----------------------------------------------------------------------------------------
	 | GND| 53 | 51 | 49 | 47 | 45 | 43 | 41 | 39 | 37 | 35 | 33 | 31 | 29 | 27 | 25 | 23 | +5V|



*/

#ifndef __AVR_ATmega2560__
#error "Select board ATMEG2560"
#endif


#define x4_A0     (22)   //PA0
#define x4_A1     (23)   //PA1
#define x4_A2     (24)   //PA2
#define x4_A3     (25)   //PA3
#define x4_A4     (26)   //PA4
#define x4_A5     (27)   //PA5
#define x4_A6     (28)   //PA6
#define x4_A7     (29)   //PA7

#define x4_B0     (37)   //PC0
#define x4_B1     (36)   //PC1
#define x4_B2     (35)   //PC2
#define x4_B3     (34)   //PC3
#define x4_B4     (33)   //PC4
#define x4_B5     (32)   //PC5
#define x4_B6     (31)   //PC6
#define x4_B7     (30)   //PC7

#define x4_C0     (49)   //PL0
#define x4_C1     (48)   //PL1
#define x4_C2     (47)   //PL2
#define x4_C3     (46)   //PL3
#define x4_C4     (45)   //PL4
#define x4_C5     (44)   //PL5
#define x4_C6     (43)   //PL6
#define x4_C7     (42)   //PL7


void setup()
{
	// x4_A, пины 22-29 (PA0-PA7)
	DDRA = B11111111;
	// x4_B, пины 30-37 (PC0-PC7)
	DDRC = B11111111;
	// x4_C, пины 42-49 (PL0-PL7)
	DDRL = B11111111;
}

void loop()
{
}


void SetPortA(uint8_t data)
{
	PORTA = data;
}

void SetPortB(uint8_t data)
{
	PORTC = data;
}

void SetPortC(uint8_t data)
{
	PORTL = data;
}

uint8_t GetPortA()
{
	return PORTA;
}

uint8_t SetPortB()
{
	return PORTC;
}

uint8_t SetPortC()
{
	return PORTL;
}
