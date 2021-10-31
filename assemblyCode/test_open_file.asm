
global _start

section .data
Snippet db 'MASSACRATION', 0dH, 0ah ;0dH + 0ah eh CR+LF
fileName db 'sample.txt'
bufferSizeRead db 100
section .bss
inputBuffer resb 100
incr resb 20


section .text
_start: 
    
open_file_sys_for_reading:          ; eax = filedescriptor
    mov eax, 5                      ; open a file
    mov ebx, fileName               ; filename with path
    mov ecx, 0                      ; access mode
    mov edx, 0700                   ; permissions
    int 0x80                        ; interruption call system
    


; open_file_sys_for_writing:          ; eax = filedescriptor
;     mov eax, 8                      ; create and open file
;     mov ebx, fileName               ; filename with path
;     mov ecx, 0700                   ; permissions
;     int 0x80                        ; interruption call system

read_from_file:  
    mov ebx, eax               ; file descriptor
    
    mov eax, 3                      ; read a file
    mov ecx, inputBuffer            ; pointer to input buffer
    mov edx, bufferSizeRead         ; buffer size (maximum number of bytes to read)
    int 0x80                        ; interruption call system

print: 
    mov eax, 4                      ; system call ID (Sys_write)
    mov ebx, 1                      ; primeiro arg: file handler stdout
    mov ecx, Snippet                ; segundo arg: ponteiro à string
    mov edx, 15                     ; terceiro arg: tamanho da string
    int 80h                         ; chamada a syscall

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
