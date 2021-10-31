section .data
Snippet db 'MASSACRATION', 0dH, 0ah ;0dH + 0ah eh CR+LF


section .text
global _start


_start: 
    mov eax, 4      ; system call ID (Sys_write)
    mov ebx, 1      ; primeiro arg: file handler stdout
    mov ecx, Snippet    ; segundo arg: ponteiro à string
    mov edx, 15     ; terceiro arg: tamanho da string
    int 80h         ; chamada a syscall
    mov ebx, Snippet
    mov eax, 8
DoMore:   
    add byte [ebx], 32
    inc ebx
    dec eax
    jnz DoMore
    mov eax, 4
    mov ebx, 1
    mov ecx, Snippet
    mov edx, 10
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
