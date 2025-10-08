# Makefile wrapper for CMake-based AVR project
# This provides simple make commands for common tasks

.PHONY: all build clean flash help validate install-deps

# Default target
all: build

# Build the project
build:
	@./build.sh

# Clean build artifacts
clean:
	@echo "Cleaning build directory..."
	@rm -rf build
	@echo "Done."

# Build with verbose output
verbose:
	@./build.sh --verbose

# Clean and rebuild
rebuild: clean build

# Flash to AVR device (requires DEVICE variable)
# Usage: make flash DEVICE=/dev/ttyUSB0
flash:
ifndef DEVICE
	@echo "Error: DEVICE not specified"
	@echo "Usage: make flash DEVICE=/dev/ttyUSB0"
	@exit 1
endif
	@if [ ! -f build/avr-playground.hex ]; then \
		echo "Error: build/avr-playground.hex not found. Build the project first."; \
		exit 1; \
	fi
	@echo "Flashing to $(DEVICE)..."
	avrdude -c arduino -p atmega328p -P $(DEVICE) -b 115200 -U flash:w:build/avr-playground.hex:i

# Validate project structure
validate:
	@./validate.sh

# Install dependencies
install-deps:
	@./install-dependencies.sh

# Help target
help:
	@echo "AVR Project Makefile"
	@echo "===================="
	@echo ""
	@echo "Available targets:"
	@echo "  make build         - Build the project (default)"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make rebuild       - Clean and rebuild"
	@echo "  make verbose       - Build with verbose output"
	@echo "  make flash         - Flash to AVR device (requires DEVICE=/dev/ttyUSB0)"
	@echo "  make validate      - Validate project structure"
	@echo "  make install-deps  - Install build dependencies"
	@echo "  make help          - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make build"
	@echo "  make flash DEVICE=/dev/ttyUSB0"
	@echo "  make clean rebuild"
