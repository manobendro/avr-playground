#!/bin/bash

# Validation script to check project structure and CMake configuration
# This script performs basic validation without requiring AVR tools

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}AVR Project Validation${NC}"
echo "======================"
echo ""

ERRORS=0
WARNINGS=0

# Check required files exist
echo -e "${YELLOW}Checking project structure...${NC}"

required_files=(
    "CMakeLists.txt"
    "cmake/avr-clang-toolchain.cmake"
    "src/main.c"
    "build.sh"
    "install-dependencies.sh"
    "README.md"
    ".gitignore"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ✓ $file exists"
    else
        echo -e "  ${RED}✗ $file missing${NC}"
        ((ERRORS++))
    fi
done

echo ""
echo -e "${YELLOW}Checking file permissions...${NC}"

executable_files=(
    "build.sh"
    "install-dependencies.sh"
)

for file in "${executable_files[@]}"; do
    if [ -x "$file" ]; then
        echo -e "  ✓ $file is executable"
    else
        echo -e "  ${RED}✗ $file is not executable${NC}"
        ((ERRORS++))
    fi
done

echo ""
echo -e "${YELLOW}Checking CMakeLists.txt syntax...${NC}"

# Check for basic CMake commands
if grep -q "cmake_minimum_required" CMakeLists.txt; then
    echo -e "  ✓ cmake_minimum_required found"
else
    echo -e "  ${RED}✗ cmake_minimum_required missing${NC}"
    ((ERRORS++))
fi

if grep -q "project(" CMakeLists.txt; then
    echo -e "  ✓ project() declaration found"
else
    echo -e "  ${RED}✗ project() declaration missing${NC}"
    ((ERRORS++))
fi

if grep -q "add_executable" CMakeLists.txt; then
    echo -e "  ✓ add_executable found"
else
    echo -e "  ${RED}✗ add_executable missing${NC}"
    ((ERRORS++))
fi

if grep -q "CMAKE_TOOLCHAIN_FILE" CMakeLists.txt; then
    echo -e "  ✓ Toolchain file reference found"
else
    echo -e "  ${RED}✗ Toolchain file reference missing${NC}"
    ((ERRORS++))
fi

echo ""
echo -e "${YELLOW}Checking toolchain file...${NC}"

if grep -q "CMAKE_SYSTEM_NAME" cmake/avr-clang-toolchain.cmake; then
    echo -e "  ✓ CMAKE_SYSTEM_NAME set"
else
    echo -e "  ${RED}✗ CMAKE_SYSTEM_NAME not set${NC}"
    ((ERRORS++))
fi

if grep -q "CMAKE_C_COMPILER" cmake/avr-clang-toolchain.cmake; then
    echo -e "  ✓ CMAKE_C_COMPILER set"
else
    echo -e "  ${RED}✗ CMAKE_C_COMPILER not set${NC}"
    ((ERRORS++))
fi

if grep -q "atmega328p" cmake/avr-clang-toolchain.cmake; then
    echo -e "  ✓ MCU target (atmega328p) specified"
else
    echo -e "  ${YELLOW}⚠ MCU target not found${NC}"
    ((WARNINGS++))
fi

echo ""
echo -e "${YELLOW}Checking source code...${NC}"

if grep -q "#include <avr/io.h>" src/main.c; then
    echo -e "  ✓ AVR headers included"
else
    echo -e "  ${RED}✗ AVR headers not included${NC}"
    ((ERRORS++))
fi

if grep -q "int main(void)" src/main.c; then
    echo -e "  ✓ main() function found"
else
    echo -e "  ${RED}✗ main() function missing${NC}"
    ((ERRORS++))
fi

echo ""
echo -e "${YELLOW}Checking README.md...${NC}"

required_sections=(
    "## Prerequisites"
    "## Building"
    "## Flashing to Hardware"
    "## Example Program"
)

for section in "${required_sections[@]}"; do
    if grep -q "$section" README.md; then
        echo -e "  ✓ $section section exists"
    else
        echo -e "  ${YELLOW}⚠ $section section missing${NC}"
        ((WARNINGS++))
    fi
done

echo ""
echo "=============================="
echo -e "${GREEN}Validation Summary${NC}"
echo "=============================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Project is ready to build on a system with AVR development tools."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Validation passed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    exit 1
fi
