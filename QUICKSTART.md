# Quick Start Guide

This is a quick reference for getting started with the AVR playground project.

## Installation (First Time Setup)

```bash
# Clone the repository
git clone https://github.com/manobendro/avr-playground.git
cd avr-playground

# Install dependencies
./install-dependencies.sh
```

## Building Your First Project

```bash
# Option 1: Using Make (recommended)
make

# Option 2: Using the build script
./build.sh

# Option 3: Manual CMake build
mkdir build && cd build
cmake ..
make
```

## Flashing to Arduino Uno

```bash
# Using Make
make flash DEVICE=/dev/ttyUSB0

# Using avrdude directly
cd build
avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -b 115200 -U flash:w:avr-playground.hex:i
```

## Common Commands

```bash
make build          # Build the project
make clean          # Clean build artifacts
make rebuild        # Clean and rebuild
make validate       # Validate project structure
make help           # Show all commands
```

## Adding New Source Files

1. Create your `.c` and `.h` files in the `src/` directory
2. Edit `CMakeLists.txt` and add your file to the SOURCES list:
   ```cmake
   set(SOURCES
       src/main.c
       src/your_file.c
   )
   ```
3. Rebuild: `make rebuild`

## Example: Enabling UART

1. Edit `CMakeLists.txt`:
   ```cmake
   set(SOURCES
       src/main.c
       src/uart.c  # Uncomment this
   )
   ```

2. Update `src/main.c`:
   ```c
   #include <avr/io.h>
   #include "uart.h"
   
   int main(void) {
       uart_init();
       uart_println("Hello from AVR!");
       
       while(1) {
           uart_println("Running...");
           _delay_ms(1000);
       }
   }
   ```

3. Rebuild and flash:
   ```bash
   make rebuild
   make flash DEVICE=/dev/ttyUSB0
   ```

## Troubleshooting

### "Permission denied" when flashing
```bash
# Linux: Add user to dialout group
sudo usermod -a -G dialout $USER
# Log out and log back in
```

### "Device not found"
```bash
# Find your device
ls /dev/tty*

# Common device names:
# Linux: /dev/ttyUSB0, /dev/ttyACM0
# macOS: /dev/tty.usbserial-*, /dev/tty.usbmodem-*
```

### Build fails with "clang: error: unsupported option '-target'"
Your Clang version may not support AVR. Install a newer version or use the AVR-GCC toolchain instead.

## Project Structure

```
src/          - Your source code files (.c, .h)
cmake/        - CMake toolchain files
build/        - Build output (auto-generated)
.github/      - CI/CD workflows
```

## Next Steps

- Read the full [README.md](README.md) for detailed information
- Modify `src/main.c` to create your own application
- Add more peripherals (timers, ADC, SPI, I2C)
- Check the GitHub Actions workflow for CI/CD examples

## Resources

- AVR Libc Documentation: https://www.nongnu.org/avr-libc/
- ATmega328P Datasheet: https://www.microchip.com/en-us/product/ATmega328P
- CMake Documentation: https://cmake.org/documentation/
