#!/bin/bash

# Dependency installation script for AVR development with avr-gcc
# Supports Ubuntu/Debian and macOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}AVR Development Environment Setup${NC}"
echo "===================================="
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies based on OS
if [ "$OS" == "linux" ]; then
    echo -e "${YELLOW}Installing dependencies for Linux...${NC}"
    
    # Update package list
    sudo apt-get update
    
    # Install essential build tools
    echo "Installing CMake and build essentials..."
    sudo apt-get install -y cmake build-essential
    
    # Install AVR toolchain
    echo "Installing AVR GCC toolchain..."
    sudo apt-get install -y avr-libc gcc-avr binutils-avr
    
    # Install Clang/LLVM with AVR backend
    echo "Installing Clang/LLVM..."
    sudo apt-get install -y clang llvm
    
    # Install AVR utilities
    echo "Installing AVR utilities..."
    sudo apt-get install -y avrdude
    
    echo -e "${GREEN}Dependencies installed successfully!${NC}"
    
elif [ "$OS" == "macos" ]; then
    echo -e "${YELLOW}Installing dependencies for macOS...${NC}"
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        echo -e "${RED}Homebrew not found. Please install Homebrew first.${NC}"
        echo "Visit: https://brew.sh"
        exit 1
    fi
    
    # Update Homebrew
    brew update
    
    # Install CMake
    echo "Installing CMake..."
    brew install cmake
    
    # Install AVR toolchain
    echo "Installing AVR GCC toolchain..."
    brew tap osx-cross/avr
    brew install avr-gcc avr-binutils avr-libc
    
    # Install Clang/LLVM (includes AVR backend)
    echo "Installing Clang/LLVM..."
    brew install llvm
    
    # Install AVR utilities
    echo "Installing AVR utilities..."
    brew install avrdude
    
    echo -e "${GREEN}Dependencies installed successfully!${NC}"
fi

echo ""
echo -e "${GREEN}Verifying installation...${NC}"
echo "========================"

# Verify installations
echo -n "CMake: "
if command_exists cmake; then
    cmake --version | head -n 1
else
    echo -e "${RED}Not found${NC}"
fi

echo -n "avr-gcc: "
if command_exists avr-gcc; then
    avr-gcc --version | head -n 1
else
    echo -e "${RED}Not found${NC}"
fi

echo -n "clang: "
if command_exists clang; then
    clang --version | head -n 1
else
    echo -e "${RED}Not found${NC}"
fi

echo -n "avr-objcopy: "
if command_exists avr-objcopy; then
    echo -e "${GREEN}Found${NC}"
else
    echo -e "${RED}Not found${NC}"
fi

echo -n "avr-size: "
if command_exists avr-size; then
    echo -e "${GREEN}Found${NC}"
else
    echo -e "${RED}Not found${NC}"
fi

echo -n "AVR libc: "
if [ -d "/usr/avr/include" ] || [ -d "/usr/local/avr/include" ] || [ -d "/opt/homebrew/avr/include" ]; then
    echo -e "${GREEN}Found${NC}"
else
    echo -e "${YELLOW}May not be found in standard location${NC}"
fi

echo -n "avrdude: "
if command_exists avrdude; then
    avrdude -? 2>&1 | head -n 1
else
    echo -e "${RED}Not found${NC}"
fi

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "To build the project:"
echo "  mkdir build && cd build"
echo "  cmake .."
echo "  make"
echo ""
echo "To flash to your AVR device:"
echo "  avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -b 115200 -U flash:w:avr-playground.hex:i"
