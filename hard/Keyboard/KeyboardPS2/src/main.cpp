#include <Arduino.h>

#include "PS2KeyMapping.h"
#include "PS2KeyRaw.h"
PS2KeyRaw keyboard;

#ifndef ARDUINO_AVR_ATmega328P_BB8
#error ATmega328P BB 8Mhz.json
#endif

#define DEBUG_CONSOLE

void (* resetFunc) (void) = 0;//объявляем функцию reset с адресом 0

#ifdef DEBUG_CONSOLE
char text[128];
#endif

#define LED_PIN     5
#define LED_PIN_S   6

int ledState = LOW;               // ledState used to set the LED
unsigned long previousMillis = 0; // will store last time LED was updated
const long interval = 100;        // interval at which to blink (milliseconds)

byte isRUS = 0;

void setSignal(void);
void clearSignal(void);
uint8_t processKeyCode(uint8_t code);


void setup(void) {
#ifdef DEBUG_CONSOLE
    Serial.begin(57600);
    while (!Serial);
    Serial.println("Start ...");
#endif
    pinMode(LED_PIN, OUTPUT);
    pinMode(LED_PIN_S, OUTPUT);
    sei();
    keyboard.begin();
    
    setSignal();
    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
    clearSignal();

    //keyboard.setLock(0);        // Don't repeat shift ctrl etc
    //keyboard.setNoBreak(1);         // No break codes for keys (when key released)
    //keyboard.setNoRepeat(1);        // Don't repeat shift ctrl etc
}

void setSignal(void) {
    digitalWrite(LED_PIN_S, HIGH);
}

void clearSignal(void) {
    digitalWrite(LED_PIN_S, LOW);
}

void ledOn(void) {
    ledState = HIGH;
    digitalWrite(LED_PIN, ledState);
    previousMillis = millis();
}

void ledOff(void) {
    if (ledState == HIGH) {
        unsigned long currentMillis = millis();
        if (currentMillis - previousMillis >= interval) {
            ledState = LOW;
            digitalWrite(LED_PIN, ledState);    
        }
    }
}

void decode(uint8_t key) {
        if (key == 0x01) Serial.println("F9");
        if (key == 0x03) Serial.println("F5");
        if (key == 0x04) Serial.println("F3");
        if (key == 0x05) Serial.println("F1");
        if (key == 0x06) Serial.println("F2");
        if (key == 0x07) Serial.println("F12");
        if (key == 0x09) Serial.println("F10");
        if (key == 0x0A) Serial.println("F8");
        if (key == 0x0B) Serial.println("F6");
        if (key == 0x0C) Serial.println("F4");
        if (key == 0x0D) Serial.println("TAB");
        if (key == 0x0E) Serial.println("`");
        if (key == 0x11) Serial.println("ALT");
        if (key == 0x12) Serial.println("SHIFT L");
        if (key == 0x14) Serial.println("CTRL L");
        if (key == 0x15) Serial.println("q");
        if (key == 0x16) Serial.println("1");
        if (key == 0x1A) Serial.println("z");
        if (key == 0x1B) Serial.println("s");
        if (key == 0x1C) Serial.println("a");
        if (key == 0x1D) Serial.println("w");
        if (key == 0x1E) Serial.println("2");
        if (key == 0x1F) Serial.println("WIN");
        if (key == 0x21) Serial.println("c");
        if (key == 0x22) Serial.println("x");
        if (key == 0x23) Serial.println("d");
        if (key == 0x24) Serial.println("e");
        if (key == 0x25) Serial.println("4");
        if (key == 0x26) Serial.println("3");
        if (key == 0x27) Serial.println("WIN");
        if (key == 0x29) Serial.println("SPACE");
        if (key == 0x2A) Serial.println("v");
        if (key == 0x2B) Serial.println("f");
        if (key == 0x2C) Serial.println("t");
        if (key == 0x2D) Serial.println("r");
        if (key == 0x2E) Serial.println("5");
        if (key == 0x2F) Serial.println("CTRL R");
        if (key == 0x31) Serial.println("n");
        if (key == 0x32) Serial.println("b");
        if (key == 0x33) Serial.println("h");
        if (key == 0x34) Serial.println("g");
        if (key == 0x35) Serial.println("y");
        if (key == 0x36) Serial.println("6");
        if (key == 0x37) Serial.println("POWER");
        if (key == 0x3A) Serial.println("m");
        if (key == 0x3B) Serial.println("j");
        if (key == 0x3C) Serial.println("u");
        if (key == 0x3D) Serial.println("7");
        if (key == 0x3E) Serial.println("8");
        if (key == 0x3F) Serial.println("SLEEP");
        if (key == 0x41) Serial.println(",");
        if (key == 0x42) Serial.println("k");
        if (key == 0x43) Serial.println("i");
        if (key == 0x44) Serial.println("o");
        if (key == 0x45) Serial.println("0");
        if (key == 0x46) Serial.println("9");
        if (key == 0x49) Serial.println(".");
        if (key == 0x4A) Serial.println("/");
        if (key == 0x4B) Serial.println("l");
        if (key == 0x4C) Serial.println(";");
        if (key == 0x4D) Serial.println("p");
        if (key == 0x4E) Serial.println("-");
        if (key == 0x52) Serial.println("'");
        if (key == 0x54) Serial.println("[");
        if (key == 0x55) Serial.println("+");
        if (key == 0x58) Serial.println("CAPS");
        if (key == 0x59) Serial.println("SHIFT R");
        if (key == 0x5A) Serial.println("ENTER");
        if (key == 0x5B) Serial.println("]");
        if (key == 0x5D) Serial.println("\\");
        if (key == 0x5E) Serial.println("WAKEUP");
        if (key == 0x66) Serial.println("ЗБ");
        if (key == 0x69) Serial.println("END");
        if (key == 0x6B) Serial.println("LEFT");
        if (key == 0x6C) Serial.println("HOME");
        if (key == 0x70) Serial.println("INS");
        if (key == 0x71) Serial.println("DEL");
        if (key == 0x72) Serial.println("DOWN");
        if (key == 0x73) Serial.println("CENTER");
        if (key == 0x74) Serial.println("RIGHT");
        if (key == 0x75) Serial.println("UP");
        if (key == 0x76) Serial.println("ESC");
        if (key == 0x77) Serial.println("NUM");
        if (key == 0x78) Serial.println("F11");
        if (key == 0x79) Serial.println("+");
        if (key == 0x7A) Serial.println("PG DOWN");
        if (key == 0x7B) Serial.println("-");
        if (key == 0x7C) Serial.println("*");
        if (key == 0x7D) Serial.println("PG UP");
        if (key == 0x7E) Serial.println("SCROLL");
        if (key == 0x83) Serial.println("F7");

        if (key == 0xFF) resetFunc();   //Serial.println("BREAK");
}

// E2 E0 XX E0 F0 XX E2
uint8_t processKeyCodeApp() {
    uint8_t code;
    while (!(code = keyboard.read()));  // 0xE0
    while (!(code = keyboard.read()));  // code
    while (!(code = keyboard.read()));  // 0xE0
    while (!(code = keyboard.read()));  // 0xF0
    while (!(code = keyboard.read()));  // code
    while (!(code = keyboard.read()));  // 0xE2
    return 0;
}

// WIN  - E0 1F E0 F0 1F 
// UP   - E0 12 E0 75 - E0 F0 75 E0 F0 12
// DOWN - E0 12 E0 72 - E0 F0 72 E0 F0 12
// LEFT - E0 12 E0 6B - E0 F0 6B E0 F0 12
// RIGHT- E0 12 E0 74 - E0 F0 74 E0 F0 12
uint8_t processKeyCodeExt() {                   // 0xE0
    uint8_t code;
    while (!(code = keyboard.read()));
    if (code == 0XF0) {                         // 0xF0
        while (!(code = keyboard.read()));      // code
        return 0;
    }    
    if (code == 0x12) {                         // 0x12
        while (!(code = keyboard.read()));
        code = processKeyCode(code);
        return code;
    }
    return processKeyCode(code);
}

// E1 14 77 E1 F0 14 F0 77
uint8_t processKeyCodeBreak() {         // 0xE1
    uint8_t code;
    while (!(code = keyboard.read()));  // 0x14
    while (!(code = keyboard.read()));  // 0x77
    while (!(code = keyboard.read()));  // 0xE1
    while (!(code = keyboard.read()));  // 0xF0
    while (!(code = keyboard.read()));  // 0x14
    while (!(code = keyboard.read()));  // 0xF0
    while (!(code = keyboard.read()));  // 0x77
    return 0xFF;    
}

uint8_t processKeyCode(uint8_t code) {
    // extended code key (start from 0xE0)
    switch (code) {
        case 0xE0:
            code = processKeyCodeExt();
            break;
        case 0xE1:
            code = processKeyCodeBreak();
            break;
        case 0xE2:
            code = processKeyCodeApp();
            break;
        default:
            break;
    }
    return code;
}

uint8_t toggleLang(void) {
    isRUS = ~isRUS;
#ifdef DEBUG_CONSOLE
    sprintf(text, "toggleLang: Keyboard: %2X", isRUS);
    Serial.println(text);
#endif
    return 0;
}

void loop(void) {
    uint8_t code;
    while ((code = keyboard.read())) {
        if (code == 0xF0) {
            while (!(code = keyboard.read()));
            processKeyCode(code);
            return;
        }
        code = processKeyCode(code);

        uint8_t key = (code <= sizeof(mapping)) ? mapping[code] : 0;
      
        decode(key);
        
        // sprintf(text, "%02X! ", code);
        // Serial.println(text);
    }
}