/*

Распиновка  ATMEGA2560
https://all-arduino.ru/wp-content/uploads/mega2_ret_by_pighixxx-d5yqsht.png
         -------------                                                                           ---------
        |    POWER    |                                                                         |   USB   |
      -----------------------------------------------------------------------------------------------------------
     |                                                                                                           |---
     |                                                                                                      AREF |   |
     |                                                                                                       GND |   |
     |                                                                                                        13 |   |
  ---|                                                                                                        12 |   |
 |   | RST                                                                                                    11 |   |
 |   | +3V                                                                                                    10 |   |
 |   | +5V                                                                                                     9 |   |
 |   | GND                                                                                                     8 |   |
 |   | GND                                                                                                       |---
 |   | VIN                                                                                                     7 |   |
  ---|                                                                                                         6 |   |
 |   |  A0                                                                                                     5 |   |
 |   |  A1                                                                                                     4 |   |
 |   |  A2                                                                                                     3 |   |
 |   |  A3                                                                                                     2 |   |
 |   |  A4                                                                                                     1 |   |
 |   |  A5                                                                                                     0 |   |
 |   |  A6                                                                                                       |---
 |   |  A7                                                                                                    14 |   |
  ---|                                                                                                        15 |   |
 |   |  A8                                                                                                    16 |   |
 |   |  A9                                                                                                    17 |   |
 |   | A10                                                                                                    18 |   |
 |   | A11                                                                                                    19 |   |
 |   | A12                                                                                                    20 |   |
 |   | A13                                                                                                    21 |   |
 |   | A14                                                                                                       |---
 |   | A15                                                                                                       |
  ---|                                                                                                           |
     | GND |  52 |  50 |  48 |  46 |  44 |  42 |  40 |  38 |  36 |  34 |  32 |  30 |  28 |  26 |  24 |  22 | +5V |
      -----------------------------------------------------------------------------------------------------------
     |     |     |     |  C2 |  C4 |  C6 |  C8 |  B9 |     |  B2 |  B4 |  B6 |  B8 |  A7 |  A5 |  A3 |  A1 |     |
     | A10 |     |     |  C1 |  C3 |  C5 |  C7 | B10 |     |  B1 |  B3 |  B5 |  B7 |  A8 |  A6 |  A4 |  A2 | C10 |
      -----------------------------------------------------------------------------------------------------------
     | GND |  53 |  51 |  49 |  47 |  45 |  43 |  41 |  39 |  37 |  35 |  33 |  31 |  29 |  27 |  25 |  23 | +5V |
                                                                                                              ^
                                                                                                              |
                                                                                                             Key
B9	- Keyboard - Reset
B10	- RomDisk - Select Disk

 ----------------------------------------------------------------
|      A B C        ROM Disk      -----   -----   -----   -----  |
|     -------                    |*    | |*    | |*    | |*    | |
| A10 |X|X|X| C10                |     | |     | |     | |     | |
| A9  |X|X|X| C9                 |  8  | |  7  | |  6  | |  5  | |
| A8  |X|X|X| C8    ---    ---   |     | |     | |     | |     | |
| A7  |X|X|X| C7   |*  |  |*  |  |     | |     | |     | |     | |
| A6  |X|X|X| C6   |   |  |   |   -----   -----   -----   -----  |
| A5  |X|X|X| C5   |   |  |   |   -----   -----   -----   -----  |
| A4  |X|X|X| C4   |   |  |   |  |     | |     | |     | |     | |
| A3  |X|X|X| C3    ---    ---   |     | |     | |     | |     | |
| A2  |X|X|X| C2                 |  1  | |  2  | |  3  | |  4  | |
| A1  |X|X|X| C1                 |     | |     | |     | |     | |
|     -------                    |    *| |    *| |    *| |    *| |
|      A B C                      -----   -----   -----   -----  |
 ----------------------------------------------------------------
B10 = LOW диск активный, при работе с одним диском на землю.

*/

#include "common.h"
#include <Arduino.h>
#define ROM_CHIP_SIZE  2048

void setup()
{
  Serial.begin(9600);
  InputModePortA();
  OutputModePortB();
  OutputModePortC();
  SetPortB(0x00);
  SetPortC(0x00);
  pinMode(PIN_ROMDISK_SELECT, OUTPUT);
  digitalWrite(PIN_ROMDISK_SELECT, LOW);    // LOW = выбранный ROM Disk
}

void loop()
{
  Serial.println();
  Serial.println(F("Select chip [1-8]:"));
  while (!Serial.available());
  char c = Serial.read();
  switch (c)
  {
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    {
      uint16_t addr = (c - '1') * ROM_CHIP_SIZE;
      loadData(addr);
      break;
    }
  }
}

char text[128];
void loadData(uint16_t addr)
{
  for (int i = 0; i < ROM_CHIP_SIZE; i++)
  {
    if ((addr & 0xF) == 0)
    {
      Serial.println();
      sprintf(text, "%04X", addr);
      Serial.print(text);
    }
    SetPortB(lowByte(addr));
    SetPortC(highByte(addr));
    delay(1);
    sprintf(text, " %02X", GetPortA());    
    Serial.print(text);
    addr++;    
  }
  Serial.println();
}
