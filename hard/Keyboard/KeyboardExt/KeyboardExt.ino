#include <Arduino.h>

//#include <PS2Keyboard.h>
//PS2Keyboard keyboard;

#define PS2_REQUIRES_PROGMEM
#include <PS2KeyAdvanced.h>
PS2KeyAdvanced keyboard;

char text[128];
byte mappingLat[256] = { 0 };
byte mappingRus[256] = { 0 };

int ledState = LOW;               // ledState used to set the LED
unsigned long previousMillis = 0; // will store last time LED was updated
const long interval = 100;        // interval at which to blink (milliseconds)

byte isRUS = 0;

#define LED_PIN         PD5
#define REG_A_CLK_PIN   PD6
#define REG_B_CLK_PIN   PD7

void saveRegA(byte value) {
    PORTB = value;
    digitalWrite(REG_A_CLK_PIN, HIGH);
    digitalWrite(REG_A_CLK_PIN, LOW);
}

void saveRegB(byte value) {
    PORTB = value;
    digitalWrite(REG_B_CLK_PIN, HIGH);
    digitalWrite(REG_B_CLK_PIN, LOW);
}

void setup() {
    Serial.begin(57600);
    
    pinMode(LED_PIN, OUTPUT);
    pinMode(REG_A_CLK_PIN, OUTPUT);
    pinMode(REG_B_CLK_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);
    digitalWrite(REG_A_CLK_PIN, LOW);
    digitalWrite(REG_B_CLK_PIN, LOW);
    DDRB = B11111111;
    saveRegA(0);
    saveRegB(0);
    
    keyboard.begin(PD3, PD2);
    keyboard.setNoBreak(1);         // No break codes for keys (when key released)
    keyboard.setNoRepeat(1);        // Don't repeat shift ctrl etc
    
    digitalWrite(LED_PIN, HIGH);
    keyboard.setLock(PS2_LOCK_SCROLL | PS2_LOCK_NUM | PS2_LOCK_CAPS);
    delay(500);
    keyboard.setLock(0);
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
uint16_t readKey() {
    uint16_t key = keyboard.read();
    ledOn();
    
    sprintf(text, "Key: %04X", key);
    Serial.println(text);

    return key;
}

void processKeyCode(uint16_t key) {
}

uint8_t toggleLang() {
    isRUS = ~isRUS;
    uint8_t value = keyboard.getLock();
    value &= ~PS2_LOCK_SCROLL;
    keyboard.setLock(value | (isRUS & PS2_LOCK_SCROLL));
    
    //sprintf(text, "Keyboard: %2X", isRUS);
    //Serial.println(text);

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

                //sprintf(text, "Keyboard: %2X", isRUS);
                //Serial.println(text);

                continue;
            }
        }
        processKeyCode(key);
/*        
*/
    }
    delay(10);
}
