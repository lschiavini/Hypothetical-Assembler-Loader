
global _start


section .data
ROWS EQU 10
COLS EQU 10
array1 db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    db  1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    
array2 db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    

Snippet db 'MASSACRATION', 0dH, 0ah ;0dH + 0ah eh CR+LF

section .bss
array3 resb 100


section .text
_start: 
    mov ecx, ROWS
    mov ebx, 0
    mov esi, 0
    mov ah, 0
    mov dh, 0
    
sum_loop: 
    mov al, [array1 + ebx + esi]
    mov dl, [array2 + ebx + esi]
    add al, dl
    add al, 0x30    ; to print as ASCII
    mov [array3+ebx+esi], al
    inc esi
    cmp esi, COLS
    jb  sum_loop

reset_cols: 
    add ebx, COLS
    mov esi, 0
    loop sum_loop   ; ecx -= 1 && if ecx != 0

print: 
    mov eax, 4      ; system call ID (Sys_write)
    mov ebx, 1      ; primeiro arg: file handler stdout
    mov ecx, Snippet    ; segundo arg: ponteiro à string
    mov edx, 15     ; terceiro arg: tamanho da string
    int 80h         ; chamada a syscall

print_result: 
    mov eax, 4      ; system call ID (Sys_write)
    mov ebx, 1      ; primeiro arg: file handler stdout
    mov ecx, array3    ; segundo arg: ponteiro à string
    mov edx, 100     ; terceiro arg: tamanho da string
    int 80h         ; chamada a syscall
    
exit: 
    mov eax, 1
    mov ebx, 0
    int 80h
