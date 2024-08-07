#ifndef PS2KeyMapping_h
#define PS2KeyMapping_h

#include "Arduino.h"

static uint8_t mapping[] = {
    0,      // 0x00 = 0
    0,      // 0x01 = 0     F9
    0,      // 0x02 = 0
    0,      // 0x03 = 0     F5
    0x04,   // 0x04 = 0x04  F3
    0x05,   // 0x05 = 0x05  F1
    0x06,   // 0x06 = 0x06  F2
    0,      // 0x07 = 0     F12
    0,      // 0x08 = 0
    0,      // 0x09 = 0     F10
    0,      // 0x0A = 0     F8
    0,      // 0x0B = 0     F6
    0x0C,   // 0x0C = 0x0C  F4
    0x0D,   // 0x0D = 0x0D  TAB
    0x0E,   // 0x0E = 0x0E  `
    0,      // 0x0F = 0

    0x10,   // 0x10 = 0
    0x11,   // 0x11 = 0x11	ALT
    0x12,   // 0x12 = 0x12	SHIFT LEFT
    0,      // 0x13 = 0
    0x14,   // 0x14 = 0x14	CTRL LEFT
    0X15,   // 0X15 = 0X15	'Q'
    0X16,   // 0X16 = 0X16	'1'
    0,      // 0X17 = 0
    0,      // 0X18 = 0
    0,      // 0X19 = 0
    0X1A,   // 0X1A = 0X1A	'Z'
    0X1B,   // 0X1B = 0X1B	'S'
    0X1C,   // 0X1C = 0X1C	'A'
    0X1D,   // 0X1D = 0X1D	'W'
    0X1E,   // 0X1E = 0X1E	'2'
    0X1F,   // 0X1F = 0X1F	WIN

    0,      // 0x20 = 0
    0x21,   // 0x21 = 0x21	'C'
    0x22,   // 0x22 = 0x22	'X'
    0x23,   // 0x23 = 0x23	'D'
    0x24,   // 0x24 = 0x24	'E'
    0x25,   // 0x25 = 0x25	'4'
    0x26,   // 0x26 = 0x26	'3'
    0x27,   // 0x27 = 0x27	WIN
    0,      // 0x28 = 0
    0x29,   // 0x29 = 0x29	SPACE
    0x2A,   // 0x2A = 0x2A	'V'
    0x2B,   // 0x2B = 0x2B	'F'
    0x2C,   // 0x2C = 0x2C	'T'
    0x2D,   // 0x2D = 0x2D	'R'
    0x2E,   // 0x2E = 0x2E	'5'
    0x2F,   // 0x2F = 0x2F	CTRL RIGHT

    0,      // 0x30 = 0
    0x31,   // 0x31 = 0x31	'N'
    0x32,   // 0x32 = 0x32	'B'
    0x33,   // 0x33 = 0x33	'H'
    0x34,   // 0x34 = 0x34	'G'
    0x35,   // 0x35 = 0x35	'Y'
    0x36,   // 0x36 = 0x36	'6'
    0x37,   // 0x37 = 0x37	POWER
    0,      // 0x38 = 0
    0,      // 0x39 = 0
    0x3A,   // 0x3A = 0x3A	'M'
    0x3B,   // 0x3B = 0x3B	'J'
    0x3C,   // 0x3C = 0x3C	'U'
    0x3D,   // 0x3D = 0x3D	'7'
    0x3E,   // 0x3E = 0x3E	'8'
    0x3F,   // 0x3F = 0x3F	SLEEP

    0,      // 0x40 = 0
    0x41,   // 0x41 = 0x41	','
    0x42,   // 0x42 = 0x42	'K'
    0x43,   // 0x43 = 0x43	'I'
    0x44,   // 0x44 = 0x44	'O'
    0x45,   // 0x45 = 0x45	'0'
    0x46,   // 0x46 = 0x46	'9'
    0,      // 0x47 = 0
    0,      // 0x48 = 0
    0x49,   // 0x49 = 0x49	'.'
    0x4A,   // 0x4A = 0x4A	'/'
    0x4B,   // 0x4B = 0x4B	'L'
    0x4C,   // 0x4C = 0x4C	';'
    0x4D,   // 0x4D = 0x4D	'P'
    0x4E,   // 0x4E = 0x4E	'-'
    0,      // 0x4F = 0

    0,      // 0x50 = 0
    0,      // 0x51 = 0
    0x52,   // 0x52 = 0x52	'''
    0,      // 0x53 = 0
    0x54,   // 0x54 = 0x54	'['
    0x55,   // 0x55 = 0x55	'+'
    0,      // 0x56 = 0
    0,      // 0x57 = 0
    0x58,   // 0x58 = 0x58	CAPS LOCK
    0x59,   // 0x59 = 0x59	SHIFT RIGHT
    0x5A,   // 0x5A = 0x5A	ENTER
    0x5B,   // 0x5B = 0x5B	']'
    0,      // 0x5C = 0
    0x5D,   // 0x5D = 0x5D	'\'
    0x5E,   // 0x5E = 0x5E	WAKEUP
    0,      // 0x5F = 0

    0,      // 0x60 = 0
    0,      // 0x61 = 0
    0,      // 0x62 = 0
    0,      // 0x63 = 0
    0,      // 0x64 = 0
    0,      // 0x65 = 0
    0x66,   // 0x66 = 0x66	ЗБ
    0,      // 0x67 = 0
    0,      // 0x68 = 0
    0x69,   // 0x69 = 0x69	END
    0,      // 0x6A = 0
    0x6B,   // 0x6B = 0x6B	LEFT
    0x6C,   // 0x6C = 0x6C	HOME
    0,      // 0x6D = 0
    0,      // 0x6E = 0
    0,      // 0x6F = 0

    0x70,   // 0x70 = 0x70	INS
    0x71,   // 0x71 = 0x71	DEL
    0x72,   // 0x72 = 0x72	DOWN
    0x73,   // 0x73 = 0x73	CENTER
    0x74,   // 0x74 = 0x74	RIGHT
    0x75,   // 0x75 = 0x75	UP
    0x76,   // 0x76 = 0x76	ESC
    0x77,   // 0x77 = 0x77	NUM LOCK
    0,      // 0x78 = 0     F11
    0x79,   // 0x79 = 0x79	'+'
    0x7A,   // 0x7A = 0x7A	PG DOWN
    0x7B,   // 0x7B = 0x7B	'-'
    0x7C,   // 0x7C = 0x7C	'*'
    0x7D,   // 0x7D = 0x7D	PG UP
    0x7E,   // 0x7E = 0x7E	SCROLL
    0,      // 0x7F = 0
};

/*
        if (key == 0x83) Serial.println("F7");

        if (key == 0xFF) resetFunc();   //Serial.println("BREAK");
*/

#endif