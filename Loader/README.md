# Hypothetical-Assembler-Loader

## Summary:

Loader.

## Project Structure:
```
├── README.md (This file)
├── /docs
│ └── trabalho1.pdf (Specifications in portuguese)
├── /tests/ (holds all .asm files as results)
├── /src/
|     └── main.cpp (principal code of the project)
|     └── stringUtils.cpp
|     └── symbolTable.cpp
|     └── objfile.cpp
|     └── chunk.cpp
|     └── utils.cpp (utils for dealing with files)
|     └── /includes/ (libraries headers directory)
|           └── utils.h (refer to utils.cpp)
|           └── stringUtils.h
|           └── symbolTable.h
|           └── objfile.h
|           └── chunk.h
|     └── /lib/ (libraries source code directory)
|          └── /args/ (lib for dealing with bash arguments)
|          |    └── /include/args.h
|          |              └── /src/args.cpp
|          |              └── CMakeLists.txt (Cmake build configurations for args)
|          └── /loader/ (actual loader lib)
|                    └── /include
|                    |       └── loader.h
|                    └── /src
|                    |       └── loader.cpp (loader with onepass algorithm)
|                    |       └── stringUtils.cpp (deals with common string uses)
|                    |       └── symbolTable.cpp (operates on symbolTable of usedVales)
|                    └── CMakeLists.txt (Cmake build configurations for loader)
├── CMakeLists.txt (Cmake build configurations)
├── build.sh (building script)
├── buildAndRun.sh (builds and runs default /tests/binDataLast.asm)
```
## Environment:
```
OS: Linux
gcc: version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04
cmake: version 3.16.3
```
## How to Run:

To build and run with sample program1.obj, program2.obj and program3.obj:
```
> chmod -x buildAndRun.sh
```
To build and run with other files:
```
> chmod -x build.sh

> sh build.sh

>./bin/assemblerMain 'NAMEOFFILE'.obj
```
OutPut Files :
 - Either errors inline or
 - /tests/'NAMEOFFILE'.out (the object binary code of the input file)



