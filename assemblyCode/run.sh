rm *.o
# nasm -f elf32 test4.asm && ld -melf_i386 test4.o && ./a.out

# nasm -f elf32 test_basedIndexAddress.asm && ld -melf_i386 test_basedIndexAddress.o && ./a.out

# nasm -f elf32 test_open_file.asm && ld -melf_i386 test_open_file.o && ./a.out
# nasm -f elf32 test_read_file.asm && ld -melf_i386 test_read_file.o && ./a.out


# nasm -f elf32 -g -F dwarf -o test_open_file.o test_open_file.asm && ld -m elf_i386 -o test_open_file test_open_file.o && chmod -x test_open_file && gdb ./test_open_file
# nasm -f elf32 -g -F dwarf -o testStack.o testStack.asm && ld -m elf_i386 -o testStack testStack.o && chmod -x testStack && gdb ./testStack

nasm -f elf32 -g -F dwarf -o calcTest.o calcTest.asm && ld -m elf_i386 -o calcTest calcTest.o && chmod -x calcTest && gdb ./calcTest
# # nasm -f elf32 -g -F dwarf -o q2.o q2.asm && ld -m elf_i386 -o q2 q2.o && chmod -x q2 && gdb ./q2