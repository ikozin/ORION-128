/*

Распиновка  ATMEG2560
https://all-arduino.ru/wp-content/uploads/mega2_ret_by_pighixxx-d5yqsht.png
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
     | A9 |    |    | C0 | C2 | C4 | C6 |    |    | B0 | B2 | B4 | B6 | A7 | A5 | A3 | A1 | C9 |
      -----------------------------------------------------------------------------------------
     | GND| 53 | 51 | 49 | 47 | 45 | 43 | 41 | 39 | 37 | 35 | 33 | 31 | 29 | 27 | 25 | 23 | +5V|
                                                                                            ^
                                                                                            |
                                                                                           Key

*/

#ifndef __AVR_ATmega2560__
#error "Select board ATMEG2560"
#endif

#define KEYCODE_ALF     B10000000
#define KEYCODE_CY      B01000000
#define KEYCODE_KOM     B00100000

#define LED_ALF         B00000100
#define LED_REC         B00001000

#define INITIAL_STATE_C B00001111

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

char text[64];
char *keyNames[]
{
  "↖", "СТР", "АР2", "F1", "F2", "F3", "F4", "",
  "ТАБ", "ПС", "ВК", "ЗБ", "←", "↑", "→", "↓",
  "0", "1", "2", "3", "4", "5", "6", "7",
  "8", "9", ":", ";", "<", "=", ">", "?",
  "@", "A", "B", "C", "D", "E", "F", "G",
  "H", "I", "J", "K", "L", "M", "N", "O",
  "P", "Q", "R", "S", "T", "U", "V", "W",
  "X", "Y", "Z", "[", "\\", "]", "^", "SPACE",  
};

byte keyboardState = INITIAL_STATE_C;

void KeyboardModeC()
{
  DDRL  = B00001111;  //Output C1-C4,Input C5-C8
  PORTL = keyboardState;
}

void setup()
{
  Serial.begin(9600);
	OutputModePortA();
  InputModePortB();
  KeyboardModeC();
  SetPortA(0x00);
}

void loop()
{
  delay(100);
  uint8_t keyCode = GetPortC();
  if ((keyCode & KEYCODE_ALF) == 0)
  {
    Serial.println("АЛФ");
    keyboardState = (keyboardState & ~LED_ALF) | ((keyboardState & LED_ALF) ^ LED_ALF);
    PORTL = keyboardState;
  }
  if ((keyCode & KEYCODE_CY) == 0)
  {
    Serial.println("СУ");
  }
  if ((keyCode & KEYCODE_KOM) == 0)
  {
    Serial.println("КОМ");
    keyboardState = (keyboardState & ~LED_REC) | ((keyboardState & LED_REC) ^ LED_REC);
    PORTL = keyboardState;
  }
  
  keyCode = GetInputKey();
  if (keyCode == 0xFF) return;
  sprintf(text, "0x%02X %s", keyCode, keyNames[keyCode]);
  Serial.println(text);
}

uint8_t GetInputKey()
{
  uint8_t keyCode = 0;
  uint8_t row = 0x01;
  while (row != 0)
  {
    SetPortA(~row);
    uint8_t data = ~GetPortB();
    if (data)
    {
      int col = 1;
      while ((data & 0x01) == 0x00)
      {
        data >>= 1;
        col ++;
        keyCode ++;
      }
      return keyCode;
    }
    keyCode += 0x08;
    row <<= 1;
  }
  return 0xFF;
}
