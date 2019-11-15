#ifndef __AVR_ATmega2560__
#error "Select board ATMEG2560"
#endif

#define OutputModePortA() DDRA = B11111111
#define OutputModePortB() DDRC = B11111111
#define OutputModePortC() DDRL = B11111111

#define InputModePortA()  DDRA = B00000000
#define InputModePortB()  DDRC = B00000000
#define InputModePortC()  DDRL = B00000000

#define SetPortA(data)  PORTA = data
#define SetPortB(data)  PORTC = data
#define SetPortC(data)  PORTL = data

#define GetPortA()      PINA
#define GetPortB()      PINC
#define GetPortC()      PINL

#define PIN_EXT             40
#define PIN_KEYBOARD_RESET  41
