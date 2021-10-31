
global _start

section .data
fileName1 db 'myfile1.txt'
fileName2 db 'myfile2.txt'
fileName_3 db 'myfile3.txt'
bufferSizeRead dw 100

section .bss
arrayx resb 100
arrayy resb 100
arrayz resb 100
resultSoma resw 1


section .text
_start: 
    
open_file1_reading:          ; eax = filedescriptor
    mov eax, 5                      ; open a file
    mov ebx, fileName1               ; filename with path
    mov ecx, 0                      ; access mode
    mov edx, 0777                   ; permissions
    int 0x80                        ; interruption call system
    

read_from_file1:  
    mov ebx, eax               ; file descriptor
    
    mov eax, 3                      ; read a file
    mov ecx, arrayx            ; pointer to input buffer
    mov edx, 200         ; buffer size (maximum number of bytes to read)
    int 0x80                        ; interruption call system

close_file1: 
    mov ebx, eax               ; file descriptor
    mov eax, 6                      ; read a file
    int 0x80                        ; interruption call system

open_file2_reading:          ; eax = filedescriptor
    mov eax, 5                      ; open a file
    mov ebx, fileName2               ; filename with path
    mov ecx, 0                      ; access mode
    mov edx, 0700                   ; permissions
    int 0x80                        ; interruption call system
    

read_from_file2:  
    mov ebx, eax               ; file descriptor
    
    mov eax, 3                      ; read a file
    mov ecx, arrayy            ; pointer to input buffer
    mov edx, 200         ; buffer size (maximum number of bytes to read)
    int 0x80                        ; interruption call system

close_file2: 
    mov ebx, eax               ; file descriptor
    mov eax, 6                      ; read a file
    int 0x80                        ; interruption call system

setup: 
    mov ecx, 100
    mov edx, 0

sum_loop: 
    mov eax, arrayx
    mov ebx, [eax + edx]
    mov eax, arrayy
    add ebx, [eax + edx]
    mov eax, arrayz
    mov [eax + edx], ebx
    inc edx
    cmp ecx, 0
    jnz  sum_loop 


open_andWrite: 
    mov     ecx, 0744         ; code continues from lesson 22
    mov     ebx, fileName_3
    mov     eax, 8
    int     80h
 
    mov     edx, 200             ; number of bytes to write - one for each letter of our contents string
    mov     ecx, arrayz       ; move the memory address of our contents string into ecx
    mov     ebx, eax            ; move the file descriptor of the file we created into ebx
    mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h                 ; call the kernel

close_file3: 
    mov ebx, eax               ; file descriptor
    mov eax, 6                      ; read a file
    int 0x80                        ; interruption call system


; print: 
;     mov eax, 4                      ; system call ID (Sys_write)
;     mov ebx, 1                      ; primeiro arg: file handler stdout
;     mov ecx, Snippet                ; segundo arg: ponteiro à string
;     mov edx, 15                     ; terceiro arg: tamanho da string
;     int 80h                         ; chamada a syscall

; open_file_sys_for_writing:          ; eax = filedescriptor
;     mov eax, 8                      ; create and open file
;     mov ebx, fileName               ; filename with path
;     mov ecx, 0700                   ; permissions
;     int 0x80                        ; interruption call system


; print_result: 
;     mov eax, 4                      ; system call ID (Sys_write)
;     mov ebx, 1                      ; primeiro arg: file handler stdout
;     mov ecx, inputBuffer            ; segundo arg: ponteiro à string
;     mov edx, bufferSizeRead         ; terceiro arg: tamanho da string
;     int 80h                         ; chamada a syscall
    
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h
