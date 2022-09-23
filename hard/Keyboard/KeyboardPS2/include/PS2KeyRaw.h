#ifndef PS2KeyRaw_h
#define PS2KeyRaw_h
#include "Arduino.h"

// Purpose: Provides an easy access to PS2 keyboards
// Based On:  Christian Weichel
class PS2KeyRaw {
    public:
        // Starts the keyboard "service" by registering the external interrupt.
        // setting the pin modes correctly and driving those needed to high.
        // The best place to call this method is in the setup routine.
        static void begin();
        
        // Returns the char last read from the keyboard.
        // If there is no char available, -1 is returned.
        static uint8_t read();
};
#endif