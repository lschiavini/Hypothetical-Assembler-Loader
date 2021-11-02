; Lucas dos Santos Schiavini - 140150749
; Aula Software Básico
; Professor - Bruno Luiggi Macchiavello Espinoza
; 01/11/2021


global _start


section .text

sumToGo: 
    
    add dword [ebp - 8], 10
    adc dword [ebp - 4], 0
    ; i = i + 10

    add dword [ebp - 12], 1
    adc dword [ebp - 16], 0
    ; aux = aux + 1

    jmp  next_64


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
    jne  next


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
    jne  sumToGo
    cmp eax, 10
    jae  sumToGo

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
    jne  next_64
    cmp edx, 0
    jne  next_64
    
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


from_string_to_int: 
        push ebp
        mov ebp, esp
        push eax
        push ebx
        push ecx
        push edx
        push esi            

        mov eax, 3          ; read value for first number
        mov ebx, 0          ; write to the STDIN file
        mov ecx, [ebp+12]   ; reserved space to store our input (known as a buffer)
        mov edx, [ebp+8]    ; number of bytes to read
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
        je  negative_number

        cmp cl, 0ah         ; checks if new line
        je  end

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
        je  end
        jmp  repeats_int

    negative_number:               ; if negative, ebx gets 1
        mov ebx, 1
        jmp  go_back

    end:
        cmp ebx, 1                  ; if ebx = 1, deals with negative
        je  deals_with_negative
        mov dword [integer], eax

        mov esi, 0

    erases_input_buffer:      
        mov ecx, [ebp+12]
        mov byte [ecx+esi], 0
        inc esi
        cmp esi, 12
        jne  erases_input_buffer

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
        jmp  end

wipe_clean_string_funct: 

    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    push esi       

    mov ecx, [ebp+12]   ; reserved space for string
    mov edx, [ebp+8]    ; number of bytes to read
    
    wipe_clean:
        mov byte [ecx+esi], 0
        inc esi
        cmp esi, edx
    jne  wipe_clean
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 8   

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
    call  print_string


shows_menu: 
    push stringA
    push byte 80
    call  wipe_clean_string_funct

    push stringB
    push byte 80
    call  wipe_clean_string_funct
    
    push stringSum
    push dword 80
    call  wipe_clean_string_funct
    
    push stringMul
    push dword 180
    call  wipe_clean_string_funct

    push menu               ; prints menu
    push dword menu_size
    call  print_string

    push option_chosen              ; gets option as string
    push dword 2
    call  read_string

    mov eax, 0
    mov al, [option_chosen]         ; goes to chosen option
    cmp al, '9'
    je  exit

    cmp  al, '6'
    je   gets_first_input
    cmp  al, '7'
    je   gets_strings_to_concat
    cmp  al, '8'
    je   gets_string_to_repeat
    jne  gets_two_inputs 
    
    continue_show_menu:
        push eax     

        pop edx                 ; Gets first integer chosen for edx

        pop eax                 

        cmp al, '1'             
        je  add
        cmp al, '2'
        je  subt
        cmp al, '3'
        je  mult
        cmp al, '4'
        je  division
        cmp al, '5'
        je  pot
        cmp al, '6'
        je  fatorial
        cmp al, '7'
        je  concat_strings
        cmp al, '8'
        je  repeat_strings

        push invalid_option           ; Prints invalid
        push invalid_option_size
        call   print_string

        jmp   shows_menu


gets_strings_to_concat: 
    ; GETS FIRST STRING
    push eax
    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string
    
    push stringA
    push dword 40
    call  read_string
    push dword [stringA]            ; pushes string on the stack

    ; GETS SECOND STRING
    push eax
    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string
    
    push stringB
    push byte 40
    call  read_string
    push dword [stringB]            ; pushes string on the stack
    
    
    pop eax
    jmp  continue_show_menu

gets_string_to_repeat: 
    push eax
    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string
    
    push stringA
    push dword 40
    call  read_string
    push dword [stringA]            ; pushes string on the stack

    push eax
    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string

    push num1
    push dword 12
    call  from_string_to_int         ; gets integer value for first number
    push dword [integer]            ; pushes number on the stack

    pop eax
    jmp  continue_show_menu

gets_first_input: 
    push eax
    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string

    push num1
    push dword 12
    call  from_string_to_int         ; gets integer value for first number
    push dword [integer]            ; pushes number on the stack


    pop eax
    jmp  continue_show_menu

gets_two_inputs: 

    push eax
    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string

    push num1
    push dword 12
    call  from_string_to_int         ; gets integer value for first number
    push dword [integer]            ; pushes number on the stack

    push input_arrow             ; prints input arrow ->
    push input_arrow_size
    call  print_string

    push num2
    push dword 12
    call  from_string_to_int    

    pop eax
    jmp  continue_show_menu



; Show multiplication result
show_result_mult: 
    push result             
    push result_size
    call   print_string       ; prints result string

    ; checks if most signif bits are negative
    cmp dword [result_2], 0
    jge  no_hifen
    ; negative_number needs inversion
    push hifen_symbol
    push dword 1
    call   print_string         

    not dword [result_1]
    not dword [result_2]
    add dword [result_1], 1
    add dword [result_2], 0

no_hifen: 
    pusha
    push dword [result_1]
    push dword [result_2]
    call   print_64
    popa

    jmp   wait_for_enter


; prints result_1, negative or positive
show_result: 
    push result              ; Prints "Resultado: " string
    push result_size
    call  print_string

    cmp dword [result_1], 0    ; If negative number, prints hifen
    jge  non_negative_number_hide_hifen
    push hifen_symbol
    push dword 1
    call  print_string         
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
    call  print_int
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

wait_for_enter:                
    push end_enter_value
    push dword 2
    call  read_string
    mov al, [end_enter_value]
    cmp al, 0ah
    jne  wait_for_enter

    jmp  shows_menu

add: 
    mov eax, edx
    add eax, [integer]     

    mov dword [result_1], eax  ; moves into result_1
    jmp  show_result

subt: 
    mov eax, edx
    sub eax, [integer]     

    mov dword [result_1], eax  ; moves into result_1
    jmp  show_result

mult: 
    mov eax, edx
    call   simple_multiplication
    ; overflow check
    mov edx, [result_2]
    cmp edx, 0x0
    je  continue_mult
    call  overFlow_msg
    
    continue_mult:
        jmp   show_result_mult

simple_multiplication: 
    imul dword [integer] 
    mov dword [result_1], eax   ; moves mult into result_1
    mov dword [result_2], edx   ; moves edx mult into result_2
    ret

division: 
    mov eax, edx
    cdq
    idiv dword [integer]       
    mov dword [result_1], eax  ; Rest of division back to result_1
    jmp  show_result


pot:  
    push ebp
    
    push eax
    push ebx
    push ecx
    push edx
    
    mov ecx, [integer] ; second number

    mov [integer], edx
    mov eax, edx
    dec ecx
    pot_loop:
        call  simple_multiplication
        mov edx, [result_2]
        cmp edx, 0x0
        jne  overflow_pot
        loop pot_loop     

    mov edx, [result_2]
    cmp edx, 0x0
    je  continue_pot

    overflow_pot:
        call  overFlow_msg

    continue_pot:
        push edx
        push ecx
        push ebx
        push eax


        pop ebp
        jmp  show_result

fatorial: 
    push ebp
    
    push eax
    push ebx
    push ecx
    push edx
    
    
    mov ecx, edx
    dec ecx
    mov [integer], edx
    fatorial_loop:
        mov eax, ecx
        call  simple_multiplication
        mov ebx, [result_1]
        mov [integer], ebx
        ; check overflow
        mov edx, [result_2]
        cmp edx, 0x0
        jne  overflow_fat

        loop fatorial_loop   
    
    mov edx, [result_2]
    cmp edx, 0x0
    je  continue_fat
    
    overflow_fat:
        call  overFlow_msg
    
    continue_fat: 
        push edx
        pop ecx
        push ebx
        push eax


        pop ebp
        jmp  show_result

overFlow_msg: 
    push overflow_msg               ; prints overflow_msg
    push dword overflow_msg_size
    call  print_string
    ret

concat_strings: 

    push eax
    push ebx
    push ecx
    push edx

    push stringSum
    push dword 80
    call  wipe_clean_string_funct

    mov esi, 0
    loop_get_string_A:
        mov al, [stringA + esi]
        
        cmp al, 0ah             ; checks if new line
        je  loop_get_string_B
        cbw
        cwde
        
        mov [stringSum + esi], eax
        inc esi
        jmp  loop_get_string_A

    mov ebx, 0
    loop_get_string_B
        inc esi
        mov al, [stringB + ebx]
        cmp al, 0ah             ; checks if new line
        je  continue_strings
        cbw
        cwde
        
        mov [stringSum + esi], eax
        inc ebx
        jmp  loop_get_string_B

    continue_strings: 

    push result              ; Prints "Resultado: " string
    push result_size
    call  print_string

    push stringSum               
    push dword 80
    call  print_string

    pop edx                 
    pop ecx
    pop ebx
    pop eax

    jmp  shows_menu


repeat_strings: 
    
    push eax
    push ebx
    push ecx
    push edx
    
    mov ecx, [integer] ; second number
    mov esi, 0
    mov ebx, 0
    mov edx, 0
    loop_get_string_A_repeat:
        mov al, [stringA + esi]
        cmp al, 0ah             ; checks if new line
        je  next_repeat
        cbw
        cwde
        
        mov [stringMul + edx], eax
        inc esi
        inc edx
        jmp  loop_get_string_A_repeat
        next_repeat:
            mov esi, 0
            inc ebx
            cmp ecx, ebx
            je  continue_repeat_strings
            jne  loop_get_string_A_repeat

    continue_repeat_strings:
        mov al, 0ah
        cbw
        cwde
        mov [stringMul + edx], eax

    push result             
    push result_size
    call  print_string


    push stringMul               
    push dword 180
    call  print_string

    pop edx                 
    pop ecx
    pop ebx
    pop eax

    jmp  shows_menu




debug_print: 
    push eax
    push ebx
    push ecx
    push edx

    mov     edx, debug_text_size     ; number of bytes to write - one for each letter plus 0Ah (line feed character)
    mov     ecx, debug_text    ; move the memory address of our message string into ecx
    mov     ebx, 1      ; write to the STDOUT file
    mov     eax, 4      ; invoke SYS_WRITE (kernel opcode 4)
    int     80h

    mov     edx, 1     ; number of bytes to write - one for each letter plus 0Ah (line feed character)
    mov     ecx, [debug_number]    ; move the memory address of our message string into ecx
    mov     ebx, 1      ; write to the STDOUT file
    mov     eax, 4      ; invoke SYS_WRITE (kernel opcode 4)
    int     80h

    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

exit: 
    mov eax, 1              
    mov ebx, 0
    int 80h




section .data
debug_text db "MASSACRATION", 0dh, 0ah
debug_text_size EQU $-debug_text
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

overflow_msg db 0dh, 0ah, "DEU OVERFLOW", 0dh, 0ah
overflow_msg_size EQU $-overflow_msg

section .bss
option_chosen resb 2
num1 resb 12
num2 resb 12
debug_number resb 1

end_enter_value resb 2
result_1 resd 1
result_2 resd 1
integer resd 1

stringA resb 40
stringB resb 40
stringSum resb 80
stringMul resb 360