# CMake Toolchain File for AVR ATmega328P with Clang/LLVM

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

# Specify the Clang cross compiler
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

# Tell CMake the compiler works without trying to run a test binary (cross-compilation)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

# AVR specific settings
set(MCU atmega328p)
set(F_CPU 16000000UL)

# Clang cross-compilation flags for AVR.
# __DELAY_BACKWARD_COMPATIBLE__ makes avr-libc use inline-assembly delay loops
# instead of __builtin_avr_delay_cycles, which Clang may not fully inline.
set(CMAKE_C_FLAGS_INIT "--target=avr -mmcu=${MCU} -DF_CPU=${F_CPU} -Os -D__DELAY_BACKWARD_COMPATIBLE__")
set(CMAKE_CXX_FLAGS_INIT "--target=avr -mmcu=${MCU} -DF_CPU=${F_CPU} -Os -D__DELAY_BACKWARD_COMPATIBLE__")

# Use avr-gcc as the linker driver so it can locate AVR crt files and avr-libc.
# Omit <FLAGS> (which contains Clang-specific --target=avr) from the linker invocation.
set(CMAKE_C_LINK_EXECUTABLE
    "avr-gcc <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE
    "avr-gcc <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-mmcu=${MCU}")

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Set the file extension for executables
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
