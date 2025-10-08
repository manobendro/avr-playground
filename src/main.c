/*
 * AVR ATmega328P LED Blink Example
 * Blinks an LED connected to PB5 (Arduino pin 13)
 */

#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN PB5
#define BLINK_DELAY_MS 1000

int main(void) {
    // Set PB5 as output
    DDRB |= (1 << LED_PIN);
    
    while (1) {
        // Toggle LED
        PORTB ^= (1 << LED_PIN);
        _delay_ms(BLINK_DELAY_MS);
    }
    
    return 0;
}
