#include "PS2KeyRaw.h"

#define BUFFER_SIZE 32
volatile uint8_t buffer[BUFFER_SIZE];
volatile int head, tail;

const uint8_t PS2_DataPin = A4;
const uint8_t PS2_IrqPin = A5;

void attachPCI() {
    *digitalPinToPCMSK(PS2_IrqPin) |= bit(digitalPinToPCMSKbit(PS2_IrqPin));    // Разрешаем PCINT для указанного пина
    PCIFR |= bit(digitalPinToPCICRbit(PS2_IrqPin));     // Очищаем признак запроса прерывания для соответствующей группы пинов
    PCICR |= bit(digitalPinToPCICRbit(PS2_IrqPin));     // Разрешаем PCINT для соответствующей группы пинов
}

void detachPCI() {
    PCICR &= ~bit(digitalPinToPCICRbit(PS2_IrqPin));    // Разрешаем PCINT для соответствующей группы пинов
}

inline bool getIrqPin() {
    return PINC & bit(digitalPinToPCMSKbit(PS2_IrqPin));
}

inline bool getDataPin() {
    return (PINC & bit(digitalPinToPCMSKbit(PS2_DataPin))) ? HIGH : LOW ;
}

inline void setIrqPin() {
    PORTC |= bit(digitalPinToPCMSKbit(PS2_IrqPin));
}

inline void setDataPin() {
    PORTC |= bit(digitalPinToPCMSKbit(PS2_DataPin));
}

// The ISR for the external interrupt
// To receive 11 bits start, 8 data, ODD parity, stop
// Interrupt every falling incoming clock edge from keyboard

ISR (PCINT1_vect) {
    // Прерывание срабатывает при любом изменении, наше нужно только переход с высокого на низкий (FALLING)
    
    if (getIrqPin()) {
        return;
    }

	static uint8_t bitcount = 0;    // Main state variable and bit count
	static uint8_t incoming;
    static uint8_t parity;
	static uint32_t prev_ms = 0;
	uint32_t now_ms;
	uint8_t val;

	val = getDataPin();
	now_ms = millis();
	if (now_ms - prev_ms > 250) {
        bitcount = 0;
    }
	prev_ms = now_ms;
    bitcount++;                     // Now point to next bit
    switch (bitcount)
    {
       case 1:  // Start bit
            incoming = 0;
            parity = 0;
            break;
       case 2:
       case 3:
       case 4:
       case 5:
       case 6:
       case 7:
       case 8:
       case 9:  // Data bits
            parity += val;          // another one received ?
            incoming >>= 1;         // right shift one place for next bit
            incoming |= (val) ? 0x80 : 0;   // or in MSbit
            break;
       case 10: // Parity check
            parity &= 1;            // Get LSB if 1 = odd number of 1's so parity should be 0
            if (parity == val) {    // Both same parity error
                parity = 0xFD;      // To ensure at next bit count clear and discard
            }
            break;
       case 11: // Stop bit
            if (parity >= 0xFD) {   // had parity error
                // Should send resend byte command here currently discard
            }
            else {                  // Good so save byte in buffer
                val = head + 1;
                if (val >= BUFFER_SIZE) {
                    val = 0;
                }
                if (val != tail) {
                    buffer[val] = incoming;
                    head = val;
                }
            }
            bitcount = 0;
            break;
       default: // in case of weird error and end of byte reception re-sync
            bitcount = 0;
            break;
      }
}

inline uint8_t get_scan_code(void) {
    int index = tail;
	if (index == head) {
        return 0;
    }
	index++;
	if (index >= BUFFER_SIZE) {
        index = 0;
    }
	tail = index;
	return buffer[index];
}

inline int available() {
    int index = head - tail;
    if (index < 0) {
        index += BUFFER_SIZE;
    }
    return index;
}

uint8_t PS2KeyRaw::read() {
    if (available()) {
        return get_scan_code();
    }
    return 0;
}

void PS2KeyRaw::begin() {
    // Устанавливаем пины в режим ввода данных
    DDRC &= ~(bit(digitalPinToPCMSKbit(PS2_DataPin)) | bit(digitalPinToPCMSKbit(PS2_IrqPin)));
    // Сбрасываем индексы
    head = 0;
    tail = 0;
    // Включаем прерывание на порту PORTC
    attachPCI();
}
