# avr-playground
AVR MCU Playground - Build C projects for AVR ATmega328P using CMake and Clang

## Overview

This repository provides a complete CMake build system for AVR microcontrollers (specifically ATmega328P) using LLVM/Clang as the compiler. It includes a simple LED blink example and automated dependency installation.

## Features

- ✅ CMake-based build system
- ✅ LLVM/Clang compiler support for AVR
- ✅ AVR ATmega328P target (Arduino Uno compatible)
- ✅ Automated dependency installation script
- ✅ Generates HEX, BIN, and ELF files
- ✅ Example LED blink program

## Prerequisites

### Required Tools

- CMake (version 3.15 or higher)
- Clang/LLVM (for AVR target support)
- AVR GCC toolchain (for AVR libraries and headers)
- avrdude (for flashing firmware)

### Automated Installation

Run the installation script to automatically install all dependencies:

```bash
./install-dependencies.sh
```

This script supports:
- **Ubuntu/Debian**: Uses apt-get
- **macOS**: Uses Homebrew

## Project Structure

```
avr-playground/
├── CMakeLists.txt                 # Main CMake configuration
├── cmake/
│   └── avr-clang-toolchain.cmake  # AVR Clang toolchain file
├── src/
│   └── main.c                     # Example LED blink program
├── build.sh                       # Quick build script
├── install-dependencies.sh        # Dependency installation script
└── README.md                      # This file
```

## Building

### Quick Build (Recommended)

Use the provided build script for easy building:

```bash
./build.sh
```

Options:
- `./build.sh --clean` - Clean build directory before building
- `./build.sh --verbose` - Show verbose build output
- `./build.sh --help` - Show help message

### Manual Build

#### Step 1: Install Dependencies

```bash
./install-dependencies.sh
```

#### Step 2: Create Build Directory

```bash
mkdir build
cd build
```

#### Step 3: Configure with CMake

```bash
cmake ..
```

#### Step 4: Build the Project

```bash
make
```

This will generate:
- `avr-playground.elf` - Executable and linkable format file
- `avr-playground.hex` - Intel HEX format (for flashing)
- `avr-playground.bin` - Binary format
- `avr-playground.map` - Memory map file

## Flashing to Hardware

To flash the compiled firmware to an Arduino Uno (ATmega328P):

```bash
avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -b 115200 -U flash:w:avr-playground.hex:i
```

**Note**: Replace `/dev/ttyUSB0` with your actual serial port:
- Linux: `/dev/ttyUSB0`, `/dev/ttyACM0`, etc.
- macOS: `/dev/tty.usbserial-*` or `/dev/tty.usbmodem-*`
- Windows: `COM3`, `COM4`, etc.

## Example Program

The included example (`src/main.c`) blinks an LED connected to pin PB5 (Arduino Uno pin 13):

```c
#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN PB5
#define BLINK_DELAY_MS 1000

int main(void) {
    DDRB |= (1 << LED_PIN);  // Set PB5 as output
    
    while (1) {
        PORTB ^= (1 << LED_PIN);  // Toggle LED
        _delay_ms(BLINK_DELAY_MS);
    }
    
    return 0;
}
```

## Customization

### Change Target MCU

Edit `cmake/avr-clang-toolchain.cmake` and `CMakeLists.txt`:

```cmake
set(MCU atmega2560)  # or atmega168, atmega32u4, etc.
```

### Change CPU Frequency

Edit `cmake/avr-clang-toolchain.cmake`:

```cmake
set(F_CPU 8000000UL)  # 8 MHz
```

### Add More Source Files

Edit `CMakeLists.txt`:

```cmake
set(SOURCES
    src/main.c
    src/uart.c
    src/timer.c
)
```

## Troubleshooting

### Clang doesn't support AVR target

Some versions of Clang may not have AVR support compiled in. Ensure you have LLVM/Clang with AVR backend:

```bash
clang --version
llc --version | grep avr
```

### AVR headers not found

Ensure `avr-libc` is installed. The headers should be in `/usr/avr/include` or `/usr/local/avr/include`.

### Permission denied when flashing

Add your user to the dialout group (Linux):

```bash
sudo usermod -a -G dialout $USER
```

Log out and log back in for changes to take effect.

## License

This project is open source and available for educational and commercial use.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.
