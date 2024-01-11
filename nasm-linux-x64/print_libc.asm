;nasm -f elf64 print_libc.asm && ld -lc -I/lib64/ld-linux-x86-64.so.2 print_libc.o && ./a.out
section .data
    output_format   db      "The integer is: %d", 10, 0  ; %d is a placeholder for the integer
    int_value       dd      72         ; 32-bit integer, initialized with 42
    another_int     dd      123456   ; Another 32-bit integer, initialized with
    ;string db "hello", 10, 0
    message1        db      "1: hello world", 10, 0; `10` note the newline, `0` note terminal at the end
    message1_size   equ     $-message1                 ; size_t

    message2        db      "2: hello world! I'm from HongKong!", 10, 0             ; `10` note the newline at the end
    message3        db      "3: ", 0x68,0x65,0x6c,0x6c,0x6f,0x20,0x77,0x6f,0x72,0x6c,0x64,0x10 , 10, 0             ; just 12 bytes

    int_value1      dq      89012313         ; 64-bit integer

    buffer          resb    21  ; Buffer to store ASCII representation of the integer (assuming a 32-bit signed integer)

    new_line        db      10,0
section .text
    global _start

_start:
    ; Print string with known length
    mov     rax, 1              ; System call number for sys_write
    mov     rdi, 1              ; File descriptor 1(stdout)
    mov     rsi, message1        ; Address of the string to print
    mov     rdx, message1_size   ; Number of bytes of the string
    syscall

    ; Print string using print(r8, r9) function
    mov     r8, message1
    mov     r9, message1_size
    call print

    ; Print string using print_string(r8) function
    mov     r8, message2
    call    print_string

    ; Print string using print_string(r8) function
    mov     r8, message3
    call    print_string

    ; Print int
    ; Convert integer to ASCII
    ; Convert the long number to a string
    mov rdi, [int_value1]    ; Source: long number
    mov rsi, buffer    ; Destination: buffer
    call int_to_ascii

    mov r8, buffer
    mov r9, 21
    call print


    ; Exit program
    mov     rax, 60  ; syscall number for exit
    xor     rdi, rdi  ; exit code 0
    syscall

string_length:
    ; Input: r8 = pointer to the null-terminated string
    ; Output: rax = length of the string
    xor     rax, rax        ; Clear rax to store the length

    count_loop:
        cmp     byte [r8], 0  ; Check for null terminator
        je      done            ; If null terminator is found, exit the loop
        inc     rax             ; Increment the length
        inc     r8             ; Move to the next character
        jmp     count_loop      ; Repeat the loop

    done:
        ret

int_to_ascii:
    ; Input: rdi - 64-bit integer
    ; Output: rsi - pointer to the null-terminated string

    mov     rax, rdi                ; Copy the number to rax
    mov     rcx, 10                 ; Set divisor to 10
    mov     rbx, rsi                 ; Copy address of buffer to rbx
    add     rbx, 20                 ; Move rbx to the end of buffer
    mov     byte [rbx], 0           ; Null-terminate the string

    .reverseLoop:
        dec     rbx                     ; Move buffer pointer backwards
        xor     rdx, rdx                ; Clear any previous remainder
        div     rcx                     ; Divide rax by 10, result in rax, remainder in rdx
        add     dl, '0'                 ; Convert remainder to ASCII
        mov     [rbx], dl               ; Store ASCII character in buffer

        test    rax, rax                ; Check if quotient is zero
        jnz     .reverseLoop             ; If not, continue loop

        mov     rsi, rbx                ; Set rsi to point to the beginning of the string
        ret

print:
    ; print function using syscall write
    ; r8: string, r9: string size
    mov rax, 1              ; System call number for sys_write
    
    mov rdi, 1              ; File descriptor 1(stdout)
    mov rsi, r8             ; Address of the string to print
    mov rdx, r9             ; Number of bytes of the string
    
    syscall

    ret

print_string:
    ; print_string function using print
    ; Input: r8 - string
    ; Get the size of the string
    mov     r8, r8
    call    string_length

    ; Call print(r8, r9)
    sub r8, rax         ; Move the address in r8 back `rax`
    mov r9, rax
    call print

    ret

print_int:
    ; print_int function using print
    ; r8: integer
