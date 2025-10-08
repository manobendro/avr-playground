cmake_minimum_required(VERSION 3.15)

# Set the toolchain file before project declaration
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/avr-clang-toolchain.cmake)

project(avr-playground C)

# Project settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# AVR MCU settings
set(MCU atmega328p)
set(F_CPU 16000000UL)

# Source files
set(SOURCES
    src/main.c
    # Uncomment to add UART support
    # src/uart.c
)

# Create the executable
add_executable(${PROJECT_NAME}.elf ${SOURCES})

# Include directories
target_include_directories(${PROJECT_NAME}.elf PRIVATE
    ${CMAKE_SOURCE_DIR}/src
)

# Compiler flags
target_compile_options(${PROJECT_NAME}.elf PRIVATE
    -Wall
    -Wextra
    -Werror
    -ffunction-sections
    -fdata-sections
)

# Linker flags
target_link_options(${PROJECT_NAME}.elf PRIVATE
    -Wl,--gc-sections
    -Wl,-Map=${PROJECT_NAME}.map
)

# Custom commands to generate hex and other files
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND llvm-objcopy -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMENT "Generating HEX file: ${PROJECT_NAME}.hex"
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND llvm-objcopy -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMENT "Generating BIN file: ${PROJECT_NAME}.bin"
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND llvm-size --format=avr --mcu=${MCU} ${PROJECT_NAME}.elf
    COMMENT "Size information:"
)

# Print build information
message(STATUS "Building for AVR ATmega328P")
message(STATUS "MCU: ${MCU}")
message(STATUS "F_CPU: ${F_CPU}")
message(STATUS "Compiler: ${CMAKE_C_COMPILER}")
