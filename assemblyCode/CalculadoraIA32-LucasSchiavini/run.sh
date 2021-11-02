rm *.o
nasm -f elf32 -g -F dwarf -o calculadora.o calculadora.asm && ld -m elf_i386 -o calculadora calculadora.o && chmod -x calculadora && gdb ./calculadora