#!/bin/bash

# Build script for AVR project
# This script simplifies the build process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BUILD_DIR="build"

echo -e "${GREEN}AVR Project Build Script${NC}"
echo "========================"
echo ""

# Parse command line arguments
CLEAN=false
VERBOSE=false
COMPILER="gcc"

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --compiler)
            COMPILER="$2"
            if [[ "$COMPILER" != "gcc" && "$COMPILER" != "clang" ]]; then
                echo -e "${RED}Invalid compiler: $COMPILER (must be gcc or clang)${NC}"
                exit 1
            fi
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -c, --clean          Clean build directory before building"
            echo "  -v, --verbose        Verbose build output"
            echo "      --compiler NAME  Compiler to use: gcc (default) or clang"
            echo "  -h, --help           Show this help message"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Clean build directory if requested
if [ "$CLEAN" = true ]; then
    echo -e "${YELLOW}Cleaning build directory...${NC}"
    rm -rf "$BUILD_DIR"
fi

# Create build directory
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}Creating build directory...${NC}"
    mkdir -p "$BUILD_DIR"
fi

# Configure with CMake
echo -e "${YELLOW}Configuring project with CMake (compiler: ${COMPILER})...${NC}"
cd "$BUILD_DIR"

CMAKE_ARGS="-DAVR_COMPILER=${COMPILER}"

if [ "$VERBOSE" = true ]; then
    cmake .. $CMAKE_ARGS -DCMAKE_VERBOSE_MAKEFILE=ON
else
    cmake .. $CMAKE_ARGS
fi

# Build the project
echo ""
echo -e "${YELLOW}Building project...${NC}"
if [ "$VERBOSE" = true ]; then
    make VERBOSE=1
else
    make
fi

echo ""
echo -e "${GREEN}Build complete!${NC}"
echo ""
echo "Generated files:"
echo "  - avr-playground.elf (ELF executable)"
echo "  - avr-playground.hex (Intel HEX format for flashing)"
echo "  - avr-playground.bin (Binary format)"
echo "  - avr-playground.map (Memory map)"
echo ""
echo "To flash to your AVR device, run:"
echo "  avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -b 115200 -U flash:w:avr-playground.hex:i"
