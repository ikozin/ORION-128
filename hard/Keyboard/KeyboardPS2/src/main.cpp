#include <Arduino.h>

#include "PS2KeyAdvanced.h"
PS2KeyAdvanced keyboard;

#define DEBUG_CONSOLE

void(* resetFunc) (void) = 0;//объявляем функцию reset с адресом 0

#ifdef DEBUG_CONSOLE
char text[128];
#endif

#define KEYCODE_MAX   0x80
byte mappingLat[KEYCODE_MAX] = { 0 };
byte mappingRus[KEYCODE_MAX] = { 0 };
byte currentKey;

#define LED_PIN 5
int ledState = LOW;               // ledState used to set the LED
unsigned long previousMillis = 0; // will store last time LED was updated
const long interval = 100;        // interval at which to blink (milliseconds)

byte isRUS = 0;

void setup() {
#ifdef DEBUG_CONSOLE
    Serial.begin(57600);
    while (!Serial);
    Serial.println("Start ...");
#endif
    pinMode(LED_PIN, OUTPUT);
    sei();
    keyboard.begin(A4, A5);
    keyboard.setNoBreak(1);         // No break codes for keys (when key released)
    keyboard.setNoRepeat(1);        // Don't repeat shift ctrl etc

    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
}

void ledOn() {
    ledState = HIGH;
    digitalWrite(LED_PIN, ledState);
    previousMillis = millis();
}

void ledOff() {
    if (ledState == HIGH) {
        unsigned long currentMillis = millis();
        if (currentMillis - previousMillis >= interval) {
            ledState = LOW;
            digitalWrite(LED_PIN, ledState);    
        }
    }
}

int16_t readKey() {
    uint16_t key = keyboard.read();
    ledOn();
#ifdef DEBUG_CONSOLE
    sprintf(text, "Key: %04X", key);
    Serial.println(text);
#endif
    return key;
}

void processKeyCode(uint16_t key) {
//  if (key >= KEYCODE_MAX) return;
//  byte* mapping = (isRUS) ? mappingRus : mappingLat;
 
}

uint8_t toggleLang() {
    isRUS = ~isRUS;
#ifdef DEBUG_CONSOLE
    sprintf(text, "toggleLang: Keyboard: %2X", isRUS);
    Serial.println(text);
#endif
    return 0;
}

void loop() {
    ledOff();
    while (keyboard.available()) {
        uint8_t key = readKey();
        // При нажатии Ctrl+Shft переключение клавиатуры и индикация светодиодом Scroll
        if (key == PS2_KEY_L_CTRL || key == PS2_KEY_R_CTRL) {
            while (!keyboard.available());
            key = readKey();
            if (key == PS2_KEY_L_SHIFT || key == PS2_KEY_R_SHIFT) {
                toggleLang();
                continue;
            }
        }
        // При нажатии ScrollLock прилетает пара PS2_KEY_ACK, альтернативное переключение клавиатуры
        if (key == PS2_KEY_ACK) {
            while (!keyboard.available());
            key = readKey();
            if (key == PS2_KEY_ACK) {
                uint8_t value = keyboard.getLock() & PS2_LOCK_SCROLL;
                isRUS = value? 0xFF: 0;
#ifdef DEBUG_CONSOLE
                sprintf(text, "loop: Keyboard: %2X", isRUS);
                Serial.println(text);
#endif
                continue;
            }
        }
        processKeyCode(key);
    }
//    delay(10);
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