#include <Arduino.h>

//#include "PS2KeyExt.h"
//PS2KeyAdvanced keyboard;
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

#define KEYCODE_MAX   0x80
byte mappingLat[KEYCODE_MAX] = { 0 };
byte mappingRus[KEYCODE_MAX] = { 0 };
byte currentKey;

#define LED_PIN     5
#define LED_PIN_S   6

int ledState = LOW;               // ledState used to set the LED
unsigned long previousMillis = 0; // will store last time LED was updated
const long interval = 100;        // interval at which to blink (milliseconds)

byte isRUS = 0;

void setSignal(void);
void clearSignal(void);


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

int16_t readKey(void) {
    uint16_t key = keyboard.read();
    if (!key) {
        return key;
    }
    ledOn();
    return key;
}

void processKeyCode(uint16_t key) {

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
    ledOff();
    while (keyboard.available()) {
        auto key = readKey();
#ifdef DEBUG_CONSOLE
        sprintf(text, "Key: %04X", key);
        Serial.println(text);
#endif

        processKeyCode(key);
    }
}
/*
void attachPCI(byte pin) {
    *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));  // Разрешаем PCINT для указанного пина
    PCIFR |= bit (digitalPinToPCICRbit(pin)); // Очищаем признак запроса прерывания для соответствующей группы пинов
    PCICR |= bit (digitalPinToPCICRbit(pin)); // Разрешаем PCINT для соответствующей группы пинов
}

void detachPCI(byte pin) {
    PCICR &= ~bit (digitalPinToPCICRbit(pin)); // Разрешаем PCINT для соответствующей группы пинов
}

ISR (PCINT1_vect) {
// Workaround for ESP32 SILICON error see extra/Porting.md
if( digitalRead( PS2_IrqPin ) )
   return;

*/