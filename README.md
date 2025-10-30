# Newton Fractal Generator

Generates a Newton Fractal for the function $z^n - 1$ = 0. The output is a PPM image (picture.ppm) where hue represents the root and brightness indicates the speed of convergence.

## Configuration
All configurable parameters are in the config.h file:

- Image size: Set via WIDTH_POW and HEIGHT_POW.
- Complex plane region: Set via XMIN, XMAX, YMIN, YMAX. Must satisfy XMIN < XMAX and YMIN < YMAX.
- Newton method precision: Controlled by MAX_ITERATIONS and EPSILON.

## Build
Tested with:

- Intel(r) Implicit SPMD Program Compiler (ISPC) 1.24.0 (LLVM 18.1.8)
- g++ 14.3.1

Build with:
```bash
ispc -O2 --target=host parallel_functions.ispc -o parallel_functions.o -h parallel_functions.h
g++ -O3 -march=native main.cpp parallel_functions.o -o main
```
## Running
Run the program with the desired exponent n:
```bash
./main [n]
```
The generated image will be saved as picture.ppm.

