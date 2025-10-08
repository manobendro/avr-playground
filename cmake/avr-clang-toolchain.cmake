# CMake Toolchain File for AVR ATmega328P with Clang

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

# Specify the cross compiler
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

# AVR specific settings
set(MCU atmega328p)
set(F_CPU 16000000UL)

# Compiler flags for AVR with Clang
set(CMAKE_C_FLAGS_INIT "-target avr -mmcu=${MCU} -DF_CPU=${F_CPU} -Os")
set(CMAKE_CXX_FLAGS_INIT "-target avr -mmcu=${MCU} -DF_CPU=${F_CPU} -Os")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-target avr -mmcu=${MCU}")

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Set the file extension for executables
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
