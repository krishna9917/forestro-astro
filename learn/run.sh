#!/bin/bash

# Assemble the assembly code using NASM
nasm -f elf64 hello.asm -o hello.o

# Check if assembly compilation was successful
if [ $? -ne 0 ]; then
    echo "Assembly compilation failed."
    exit 1
fi

# Link the object file using ld, specifying _start as the entry point
ld -o hello hello.o 

# Check if linking was successful
if [ $? -ne 0 ]; then
    echo "Linking failed."
    exit 1
fi

echo "--------------------------------"
echo "Running the executable:"
echo "--------------------------------"

# Run the executable
./hello

# Check if execution was successful
if [ $? -ne 0 ]; then
    echo "Execution failed."
    exit 1
fi

echo "--------------------------------"
echo "Program finished."
