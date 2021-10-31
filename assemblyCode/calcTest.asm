
global _start


section .text


; Print 64 byte integer
; gets EDX and EAX
print_64: 
    push ebp
    mov ebp, esp

    mov esi, 0
    sub esp, 128

    mov edi, 0
    mov eax, 0
    mov ecx, 0

    ; 21 spaces for printing
    sub esp, 21
    mov esi, 21

    ; puts /n on the end
    mov byte [esp + esi], 0ah
    
next_64: 
    mov dword eax, [ ebp + 12 ]
    mov dword ebx, [ ebp + 8 ]

    mov dword ecx, [ ebp - 8 ]
    mov dword edx, [ ebp - 4 ]

    sub eax, ecx
    sbb ebx, edx

    cmp ebx, 0
    jne sumToGo
    cmp eax, 10
    jae sumToGo

    ; saves eax
    add al, '0'
    dec esi
    mov byte [esp + esi], al

    ; saves new temp values
    mov dword ecx, [ ebp - 12 ]
    mov dword edx, [ ebp - 16 ]

    mov dword [ ebp + 12 ], ecx
    mov dword [ ebp + 8 ], edx

    ; set to zero to try again
    mov dword [ ebp - 8 ], 0
    mov dword [ ebp - 4 ], 0
    mov dword [ ebp - 12 ], 0
    mov dword [ ebp - 16 ], 0

    ; go_back if 64 bits isn't zero
    cmp ecx, 0
    jne next_64
    cmp edx, 0
    jne next_64
    
    ; Shows on screen
    add esi, esp
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, 21
    int 80h
    

    add esp, 21

    add esp, 128

    pop ebp
    ret 8

sumToGo: 
    
    add dword [ebp - 8], 10
    adc dword [ebp - 4], 0
    ; i = i + 10

    add dword [ebp - 12], 1
    adc dword [ebp - 16], 0
    ; aux = aux + 1

    jmp next_64



; Prints int function
; Gets integer of 32bits
; uses eax, ebc, ecx, edx, esi
print_int: 
    push ebp
    mov ebp, esp
    mov esi, 0
    mov eax, 0
    mov ecx, 0
    ; least 16 bits on ax
    ; most significant 16 bits in dx
    mov eax, [ebp + 8]
    mov ebx, 10

    sub esp, 11
    ; puts '\n' on the end
    inc esi
    mov ecx, ebp
    sub ecx, esi
    mov byte [ecx], 0ah
next: 
    inc esi
    mov edx, 0
    ; mov edx, eax
    ; shr edx, 16
    div ebx

    ; puts value on stack
    mov ecx, ebp
    sub ecx, esi
    add edx, '0'
    mov byte [ecx], dl
    cmp eax, 0
    jne next


    ; prints value pointed by esp
    mov eax, 4
    mov ebx, 1

    mov ecx, ebp
    sub ecx, esi
    ; sub ecx, 1

    mov edx, esi
    int 80h

    add esp, 11
    pop ebp
    ret 4




from_string_to_int: 
        push ebp
        mov ebp, esp
        push eax
        push ebx
        push ecx
        push edx
        push esi            

        mov eax, 3
        mov ebx, 0
        mov ecx, [ebp+12]
        mov edx, [ebp+8]
        int 80h            

        mov esi, 0
        mov eax, 0
        mov ecx, 0
        mov ebx, 0
        mov edx, 0

    repeats_int:
        mov ecx, 0
        mov ecx, [ebp+12]
        mov cl, [ecx+esi]   ; gets each character from string in ecx
        cmp cl, 2dh         ; checks if is hifen
        je negative_number

        cmp cl, 0ah         ; checks if new line
        je end

        sub cl, 30h         ; Subtract 0x30 to get decimal value
        mov edx, 10
        push eax
        mov al, cl          ; setting up to extend from byte to word
        cbw
        cwde
        mov ecx, eax        
        pop eax
        mul edx             ; Mutiplies by 10 
        add eax, ecx        ; adds actual to total
    go_back:
        inc esi
        cmp esi, 11         ; checks if already passed 11 char limit
        je end
        jmp repeats_int

    negative_number:               ; if negative, ebx gets 1
        mov ebx, 1
        jmp go_back

    end:
        cmp ebx, 1                  ; if ebx = 1, deals with negative
        je deals_with_negative
        mov dword [integer], eax

        mov esi, 0

    erases_input_buffer:      
        mov ecx, [ebp+12]
        mov byte [ecx+esi], 0
        inc esi
        cmp esi, 12
        jne erases_input_buffer

        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax
        pop ebp
        ret 8             

    deals_with_negative:              ; gets negative out of number
        neg eax
        mov ebx, 0
        jmp end

; Print String
; Receives (address, size)
print_string: 
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx                ; stacks previous values of parameters   

    mov eax,4
    mov ebx,1
    mov ecx,[ebp+12]
    mov edx,[ebp+8]
    int 80h                 

    pop edx                 ; Gets previous values of parameters
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 8                   ; Gets eip

; Read String function
; Gets string address and max size
read_string: 
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx        

    mov eax, 3
    mov ebx, 0
    mov ecx, [ebp+12]
    mov edx, [ebp+8]
    int 80h                

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 8                 

_start: 


print_welcome: 
    push beginText              
    push dword beginText_size
    call print_string


shows_menu: 
    push menu               ; prints menu
    push dword menu_size
    call print_string

    push option_chosen              ; gets option as string
    push dword 2
    call read_string

    mov eax, 0
    mov al, [option_chosen]         ; goes to chosen option
    cmp al, '9'
    je exit

    push eax

    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call print_string

    push num1
    push dword 12
    call from_string_to_int         ; gets integer value for first number
    push dword [integer]            ; pushes number on the stack

    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call print_string

    push num2
    push dword 12
    call from_string_to_int         

    pop edx                 ; Gets first integer chosen for edx

    pop eax                 

    cmp al, '1'             
    je add
    cmp al, '2'
    je subt
    cmp al, '3'
    je mult
    cmp al, '4'
    je division
    cmp al, '5'
    je pot
    cmp al, '6'
    je fatorial
    cmp al, '7'
    je concatStrings
    cmp al, '8'
    je repeatStrings

    push invalid_option           ; Prints invalid
    push invalid_option_size
    call print_string

    jmp shows_menu

; Show multiplication result
show_result_mult: 
    push result             
    push result_size
    call print_string       ; prints result string

    ; checks if most signif bits are negative
    cmp dword [result_2], 0
    jge no_hifen
    ; negative_number needs inversion
    push hifen_symbol
    push dword 1
    call print_string         

    not dword [result_1]
    not dword [result_2]
    add dword [result_1], 1
    add dword [result_2], 0

no_hifen: 
    pusha
    push dword [result_1]
    push dword [result_2]
    call print_64
    popa

    jmp wait_for_enter


; prints result_1, negative or positive
show_result: 
    push result              ; Prints "Resultado: " string
    push result_size
    call print_string

    cmp dword [result_1], 0    ; If negative number, prints hifen
    jge non_negative_number_hide_hifen
    push hifen_symbol
    push dword 1
    call print_string         
    mov eax, [result_1]
    neg eax
    mov dword [result_1], eax  ; Uses neg on result_1 to become positive
non_negative_number_hide_hifen: 
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push dword [result_1]  ; print int as string
    call print_int
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
wait_for_enter:                
    push end_enter_value
    push dword 2
    call read_string
    mov al, [end_enter_value]
    cmp al, 0ah
    jne wait_for_enter

    jmp shows_menu

add: 
    mov eax, edx
    add eax, [integer]     

    mov dword [result_1], eax  ; moves into result_1
    jmp show_result

subt: 
    mov eax, edx
    sub eax, [integer]     

    mov dword [result_1], eax  ; moves into result_1
    jmp show_result

mult: 
    mov eax, edx
    imul dword [integer] 

    mov dword [result_1], eax  ; moves mult into result_1
    mov dword [result_2], edx ; moves edx mult into result_2

    jmp show_result_mult

division: 
    mov eax, edx
    cdq
    idiv dword [integer]       

    mov dword [result_1], eax  ; Rest of division back to result_1

    jmp show_result

mod: 
    mov eax, edx
    cdq
    idiv dword [integer]     

    mov dword [result_1], edx  

    jmp show_result

pot:  ; TODO pot
    mov eax, edx
    cdq
    idiv dword [integer]     

    mov dword [result_1], edx  

    jmp show_result

fatorial: ; TODO fatorial
    mov eax, edx
    cdq
    idiv dword [integer]     

    mov dword [result_1], edx  

    jmp show_result

concatStrings: ; TODO concatStrings
    mov eax, edx
    cdq
    idiv dword [integer]     

    mov dword [result_1], edx  

    jmp show_result


repeatStrings: ; TODO repeatStrings
    mov eax, edx
    cdq
    idiv dword [integer]     

    mov dword [result_1], edx  

    jmp show_result



exit: 
    mov eax, 1              
    mov ebx, 0
    int 80h


section .data

beginText db "Calculadora IA-32", 0dh, 0ah
beginText_size EQU $-beginText
invalid_option db "OPÇÃO INVÁLIDA", 0dh, 0ah
invalid_option_size EQU $-invalid_option
input_arrow db "=> "
input_arrow_size EQU $-input_arrow
result db "Resultado: "
result_size EQU $-result
hifen_symbol db "-"
menu db 0dh, 0ah, "Menu:", 0dh, 0ah, "- 1: Soma", 0dh, 0ah, "- 2: Subtração", 0dh, 0ah, "- 3: Multiplicação", 0dh, 0ah, "- 4: Divisão", 0dh, 0ah, "- 5: Potenciação", 0dh, 0ah, "- 6: Fatorial", 0dh, 0ah, "- 7: Concatenar strings", 0dh, 0ah, "- 8: Repetição de Strings", 0dh, 0ah,  "- 9: Sair", 0dh, 0ah, "-> " 
menu_size EQU $-menu

section .bss
option_chosen resb 2
num1 resb 12
num2 resb 12
end_enter_value resb 2
result_1 resd 1
result_2 resd 1
integer resd 1