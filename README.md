# Source-to-source compiler Project

This project implements a compiler using Bison and Flex. It takes input files in a custom language format and generates corresponding C files, which are then compiled into executable binaries.

## Features

- Implements a custom language parser using Bison and Flex.
- Translates input files into C code.
- Compiles the generated C code into executable binaries.
- Supports error handling and reporting.

## Getting Started

### Prerequisites

To build and run the compiler, you'll need:

- Bison
- Flex
- GCC (GNU Compiler Collection)

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/npapoutsakis/theory_of_computation_project.git
   ```

2. Navigate to the project directory:

   ```bash
   cd theory_of_computation_project
   ```

3. Build the compiler:

   ```bash
   make
   ```

### Usage

1. Prepare your input files in the custom language format (e.g., example.la, correct1.la, correct2.la).

2. Run the compiler:

   ```bash
   make test
   ```

   This will compile the input files, generate C code, and attempt to compile the generated C files into executable binaries. Results will be displayed in the terminal.

### Cleaning Up

To clean up generated files and executables, run:

    ```bash
    make clean
    ```
