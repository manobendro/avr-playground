/*
 * UART communication module for AVR ATmega328P
 * Provides basic serial communication functionality
 */

#ifndef UART_H
#define UART_H

#include <stdint.h>

// UART configuration
#define BAUD_RATE 9600
#define UART_BUFFER_SIZE 64

// Function prototypes
void uart_init(void);
void uart_transmit(uint8_t data);
uint8_t uart_receive(void);
void uart_print(const char* str);
void uart_println(const char* str);

#endif // UART_H
