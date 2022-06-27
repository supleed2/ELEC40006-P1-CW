# ELEC40006-P1-CW

## CPUProject Courseowrk for ELEC40006 Electrical Design Project 1

General-purpose, ARM-based CPU designed as part of the Electronics Design Project at Imperial College London. This project was created by:

- [Aadi Desai](https://github.com/supleed2)
- [Benjamin Ramhorst](https://github.com/bo3z)
- [Kacper Neumann](https://github.com/kmn219)

### Project Description

The main goal of this project was to build a general-purpose CPU, capable of performing a wide range of operations including arithmetic operations such as addition, subtraction and multiplication; logic operations such as bitwise operations and conditionals; memory operations such as load and store. The CPU should be tested with a wide range of mathematical functions and programming algorithms, including but not limited to calculating a Fibonacci number, generating pseudo-random numbers, and traversing a linked list. The CPU is expected to complete these operations efficiently and correctly, using only built-in hardware and instructions.

### Quick Links

- [Full project documentation, including design choices, implementation and planning](./docs/Report.pdf)
- [Video demonstration of the project](./docs/Demo.mp4)
- [Instruction set documentation](./docs/ISA.pdf)
- [CPU block diagram](./docs/cpuStructure.png)
- [CPU source files](./src/)

### Technologies Used

- Quartus Prime, used for block schematics and testing
- Verilog HDL, used for multiplication and ALU
- C++, for writing benchmark tests and automating testing

### CPU Technical Requirements

1. 16-bit instruction length
1. The CPU should be able to perform a wide range of arithmetic-logic operations.
1. Efficient multiplication must be built-into the CPU
1. Enough memory to store 2K words of instructions and data
1. The CPU must have a stack, but there are no other hardware requirement on how this is implmented
1. The CPU must be pipelined to improve performance
1. The CPU dynamic power consumption should not be above 50 mW
1. The maximum clock frequency should be at least 100 MHz at 0 degrees Celsius
1. The CPU must have at least four registers to enable work with more data concurrently. Preferably eight, if instruction length allows.

### CPU Testing

The CPU should be tested with three algorithms, as described below. It must produce correct results, but also be efficient, both in terms of power and speed. The algorithms used for testing should be:

1. Calculating the nth Fibonacci number using recursion.
1. Calculating pseudo-random integers.
1. Traversing a linked list of integers and searching for a specific element in the list.
