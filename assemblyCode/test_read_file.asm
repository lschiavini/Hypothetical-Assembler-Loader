; Compile with: nasm -f elf read.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 read.o -o read
; Run with: ./read
 
; %include    'functions.asm'
 
global  _start


 
SECTION .text
 
_start: 
 
    ; mov     ecx, 0777o          ; Create file from lesson 22
    ; mov     ebx, filename
    ; mov     eax, 8
    ; int     80h
 
    ; mov     edx, 12             ; Write contents to file from lesson 23
    ; mov     ecx, contents
    ; mov     ebx, eax
    ; mov     eax, 4
    ; int     80h
 
    mov     ecx, 0              ; Open file from lesson 24
    mov     ebx, filename
    mov     eax, 5
    int     80h
 
    mov     edx, 12             ; number of bytes to read - one for each letter of the file contents
    mov     ecx, fileContents   ; move the memory address of our file contents variable into ecx
    mov     ebx, eax            ; move the opened file descriptor into EBX
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel
 
    ; mov     eax, fileContents   ; move the memory address of our file contents variable into eax for printing

print_result: 
    mov eax, 4                      ; system call ID (Sys_write)
    mov ebx, 1                      ; primeiro arg: file handler stdout
    mov ecx, fileContents            ; segundo arg: ponteiro à string
    mov edx, 10000        ; terceiro arg: tamanho da string
    int 80h                         ; chamada a syscall

    ; call    sprintLF            ; call our string printing function
 
    ; call    quit                ; call our quit function


SECTION .data
filename db 'sample.txt', 0h    ; the filename to create
contents db 'Hello world!', 0h  ; the contents to write
 
SECTION .bss
fileContents resb 10000,          ; variable to store file contents