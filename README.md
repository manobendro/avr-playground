# avr-playground
AVR MCU Playground - Build C projects for AVR ATmega328P using CMake with AVR-GCC or Clang

## Overview

This repository provides a complete CMake build system for AVR microcontrollers (specifically ATmega328P). It supports both **AVR-GCC** and **Clang/LLVM** as compilers — you choose at build time. GCC is the default. It includes a simple LED blink example and automated dependency installation.

## Features

- ✅ CMake-based build system
- ✅ AVR-GCC compiler support
- ✅ Clang/LLVM compiler support (user-selectable)
- ✅ AVR ATmega328P target (Arduino Uno compatible)
- ✅ Automated dependency installation script
- ✅ Generates HEX, BIN, and ELF files
- ✅ Example LED blink program
- ✅ UART communication module (optional)
- ✅ Makefile wrapper for convenience
- ✅ GitHub Actions CI/CD workflow (builds with both GCC and Clang)

## Build Status

Both compilers are verified to produce correct AVR firmware:

| Compiler | Version tested | Flash usage |
|---|---|---|
| avr-gcc | 7.3.0 | 162 bytes |
| clang | 18.1.3 | 168 bytes |

## Project Structure

```
avr-playground/
├── .github/
│   └── workflows/
│       └── build.yml                  # CI/CD workflow — matrix build (GCC + Clang)
├── CMakeLists.txt                     # Main CMake configuration
├── Makefile                           # Makefile wrapper for common tasks
├── cmake/
│   ├── avr-gcc-toolchain.cmake        # AVR-GCC toolchain file
│   └── avr-clang-toolchain.cmake      # Clang/LLVM toolchain file
├── src/
│   ├── main.c                         # Example LED blink program
│   ├── uart.c                         # UART module implementation (optional)
│   └── uart.h                         # UART module header (optional)
├── build.sh                           # Quick build script
├── install-dependencies.sh            # Dependency installation script
├── validate.sh                        # Project validation script
└── README.md                          # This file
```

## Prerequisites

### Required Tools

| Tool | Purpose | Required for |
|---|---|---|
| CMake ≥ 3.15 | Build system | All builds |
| `gcc-avr` + `binutils-avr` | AVR cross-compiler and linker | All builds (Clang uses avr-gcc for linking) |
| `avr-libc` | AVR C standard library and headers | All builds |
| `clang` + `llvm` | LLVM/Clang compiler | Clang builds only |
| `avrdude` | Flash firmware to hardware | Flashing only |

### Automated Installation

Run the installation script to automatically install all dependencies:

```bash
./install-dependencies.sh
```

This script supports **Ubuntu/Debian** (via `apt-get`) and **macOS** (via Homebrew).

#### Manual installation — Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install -y cmake gcc-avr binutils-avr avr-libc clang llvm avrdude
```

#### Manual installation — macOS

```bash
brew tap osx-cross/avr
brew install cmake avr-gcc avr-binutils avr-libc llvm avrdude
```

## Building

### Quick Build — using the build script

```bash
# Build with AVR-GCC (default)
./build.sh

# Build with Clang/LLVM
./build.sh --compiler clang

# Clean then build
./build.sh --clean

# Verbose output
./build.sh --verbose

# All options combined
./build.sh --compiler clang --clean --verbose

# Show help
./build.sh --help
```

### Quick Build — using Make

```bash
make              # Build with GCC (default)
make clean        # Remove build artifacts
make rebuild      # Clean then build
make validate     # Validate project structure
make help         # Show all available targets
```

### Manual Build — step by step

#### Step 1: Install dependencies

```bash
./install-dependencies.sh
```

#### Step 2: Create a build directory

```bash
mkdir build && cd build
```

#### Step 3: Configure with CMake

```bash
# AVR-GCC (default — both of these are equivalent)
cmake ..
cmake .. -DAVR_COMPILER=gcc

# Clang/LLVM
cmake .. -DAVR_COMPILER=clang
```

#### Step 4: Compile

```bash
make
```

#### Step 5: Verify output

After a successful build the `build/` directory contains:

```
avr-playground.elf   # ELF executable (used by avrdude and debuggers)
avr-playground.hex   # Intel HEX format — flash this to the device
avr-playground.bin   # Raw binary
avr-playground.map   # Linker memory map
```

`avr-size` prints a memory summary automatically after each build, for example:

```
AVR Memory Usage
----------------
Device: atmega328p

Program:     162 bytes (0.5% Full)   ← GCC
Program:     168 bytes (0.5% Full)   ← Clang

Data:          0 bytes (0.0% Full)
```

### Compiler selection reference

| Method | GCC | Clang |
|---|---|---|
| `cmake` flag | `cmake .. -DAVR_COMPILER=gcc` | `cmake .. -DAVR_COMPILER=clang` |
| `build.sh` flag | `./build.sh --compiler gcc` | `./build.sh --compiler clang` |
| Custom toolchain | `cmake .. -DCMAKE_TOOLCHAIN_FILE=cmake/avr-gcc-toolchain.cmake` | `cmake .. -DCMAKE_TOOLCHAIN_FILE=cmake/avr-clang-toolchain.cmake` |

## Flashing to Hardware

### Using Make

```bash
make flash DEVICE=/dev/ttyUSB0
```

### Using avrdude directly

```bash
avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -b 115200 \
    -U flash:w:build/avr-playground.hex:i
```

Replace `/dev/ttyUSB0` with your actual serial port:
- **Linux**: `/dev/ttyUSB0`, `/dev/ttyACM0`, …
- **macOS**: `/dev/tty.usbserial-*`, `/dev/tty.usbmodem-*`
- **Windows**: `COM3`, `COM4`, …

## Example Program

The included example (`src/main.c`) blinks an LED on PB5 (Arduino Uno pin 13):

```c
#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN PB5
#define BLINK_DELAY_MS 1000

int main(void) {
    DDRB |= (1 << LED_PIN);   // Set PB5 as output

    while (1) {
        PORTB ^= (1 << LED_PIN);  // Toggle LED
        _delay_ms(BLINK_DELAY_MS);
    }

    return 0;
}
```

## Customization

### Adding UART Support

1. Edit `CMakeLists.txt` and uncomment the UART source:

   ```cmake
   set(SOURCES
       src/main.c
       src/uart.c  # uncomment
   )
   ```

2. Include UART in `main.c`:

   ```c
   #include "uart.h"

   int main(void) {
       uart_init();
       uart_println("Hello, AVR!");
   }
   ```

### Changing the Target MCU

Edit both toolchain files and `CMakeLists.txt`:

```cmake
set(MCU atmega2560)  # or atmega168, atmega32u4, etc.
```

Files to update:
- `cmake/avr-gcc-toolchain.cmake`
- `cmake/avr-clang-toolchain.cmake`
- `CMakeLists.txt` (the `set(MCU ...)` line)

### Changing CPU Frequency

Edit both toolchain files:

```cmake
set(F_CPU 8000000UL)  # 8 MHz
```

### Adding Source Files

Edit `CMakeLists.txt`:

```cmake
set(SOURCES
    src/main.c
    src/uart.c
    src/timer.c
)
```

## Troubleshooting

### AVR headers not found

Ensure `avr-libc` is installed. Headers should be at `/usr/avr/include` (Linux) or `/usr/local/avr/include` (macOS):

```bash
ls /usr/avr/include/avr/io.h
```

If missing, install with `sudo apt-get install avr-libc` or `brew install avr-libc`.

### Clang AVR backend not available

Verify your Clang has the AVR backend compiled in:

```bash
clang --version
llc --version | grep avr   # should print "avr    - Atmel AVR Microcontroller"
```

On Ubuntu/Debian `clang` 7+ and all modern distributions include it by default. On macOS install via `brew install llvm`.

### `__builtin_avr_delay_cycles` undefined reference

This can happen with older Clang versions. The toolchain file already adds `-D__DELAY_BACKWARD_COMPATIBLE__` to work around it. If you still see this, ensure you are using `cmake/avr-clang-toolchain.cmake` and not a custom toolchain.

### Permission denied when flashing

Add your user to the `dialout` group (Linux), then log out and back in:

```bash
sudo usermod -a -G dialout $USER
```

## License

This project is open source and available for educational and commercial use.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

