;nasm -f elf64 simple_compiler.asm && ld simple_compiler.o && ./a.out

section .data
    input_filename  db 'print.txt', 0    ; Name of the source code file
    output_filename db 'print.asm', 0  ; Name of the output assembly code file
    buffer_size     equ 1024                   ; Buffer size for reading source code

    err_msg           db  "Error!", 10   ; const char *
    err_msg_len       equ $-err_msg               ; size_t

section .bss
    source_buffer resb buffer_size            ; Buffer to store source code
    lexeme_buffer resb buffer_size            ; Buffer to store the current lexeme
    lexeme_length resq 1                      ; Variable to store the length of the lexeme

section .text
    global _start

_start:
    ; Open the source code file for reading
    mov rdi, input_filename                ; Source code filename
    mov rsi, 0                             ; Flags: O_RDONLY
    mov rdx, 0                             ; Mode: 0 (ignored when opening an existing file)
    mov rax, 2                             ; syscall: open
    syscall
    test rax, rax                          ; Check for errors
    js  exit_error                         ; If error, exit
    mov r8, rax                            ; Store source code file descriptor in r8

    ; Open the output assembly code file for writing (create if it doesn't exist)
    mov rdi, output_filename               ; Output filename
    mov rsi, 0x201 | 0x40                  ; Flags: O_WRONLY | O_CREAT
    mov rdx, 0o644                         ; Mode: 644 (rw-r--r--)
    mov rax, 2                             ; syscall: open
    syscall
    test rax, rax                          ; Check for errors
    js  exit_error                         ; If error, exit
    mov r9, rax                            ; Store output file descriptor in r9

    ; Read the source code into the buffer
    mov rdi, r8                            ; Source code file descriptor
    mov rsi, source_buffer                 ; Buffer address
    mov rdx, buffer_size                   ; Number of bytes to read
    mov rax, 0                             ; syscall: read
    syscall
    test rax, rax                          ; Check for errors
    js  exit_error                         ; If error, exit
    mov rcx, rax                           ; Store the number of bytes read in rcx

    ; Perform lexer (simplified for illustration)
    mov rdi, lexeme_buffer                 ; Buffer to store the current lexeme
    mov rsi, source_buffer                 ; Point to the source buffer
    mov rdx, rcx                           ; Number of bytes to process
    call lexer                             ; Call the lexer function

    mov rdi, err_msg                 ; Buffer address
    mov rsi, err_msg_len               ; Length of the lexeme
    call print

    ; Write the assembly code to the output file
    mov rdi, r9                            ; Output file descriptor
    mov rsi, lexeme_buffer                 ; Buffer address
    mov rdx, [lexeme_length]               ; Length of the lexeme
    mov rax, 1                             ; syscall: write
    syscall
    test rax, rax                          ; Check for errors
    js  exit_error                         ; If error, exit

    ; Close the source code file
    mov rdi, r8                            ; Source code file descriptor
    mov rax, 3                             ; syscall: close
    syscall
    test rax, rax                          ; Check for errors
    js  exit_error                         ; If error, exit

    ; Close the output assembly code file
    mov rdi, r9                            ; Output file descriptor
    mov rax, 3                             ; syscall: close
    syscall
    test rax, rax                          ; Check for errors
    js  exit_error                         ; If error, exit

    ; Exit the program
    mov rax, 60                            ; syscall: exit
    xor rdi, rdi                           ; exit code 0
    syscall

lexer:
    ; Lexer function (simplified for illustration)
    ; Tokenize the source code and generate assembly code for each token
    ; This function assumes a simple language with a print statement
    ; and string literals. It outputs the assembly code for simplicity.

    ; Reset lexeme length
    mov qword [lexeme_length], 0

    ; Loop through the source code
    lexer_loop:
        cmp byte [rsi], 0                ; Check for null terminator
        je lexer_done                     ; If end of source code, exit lexer

        ; Check for "print" keyword
        mov rax, [rsi]
        cmp rax, 'p' << 8 | 'r'
        jne lexer_next_char               ; If not 'p', continue to the next character

        mov rax, [rsi + 2]
        cmp rax, 'i' << 8 | 'n'
        jne lexer_next_char               ; If not 'i', continue to the next character

        mov rax, [rsi + 4]
        cmp rax, 't' << 8 | 0
        jne lexer_next_char               ; If not 't', continue to the next character

        ; Found "print" keyword, generate assembly code
        mov rsi, [rsi + 6]                ; Move to the start of the string literal
        mov rdi, lexeme_buffer             ; Destination buffer
        call copy_string                   ; Copy the string literal to lexeme_buffer

        ; Output assembly code for printing the string
        mov rdi, r9                        ; Output file descriptor
        mov rsi, lexeme_buffer             ; Buffer address
        mov rdx, [lexeme_length]           ; Length of the lexeme
        mov rax, 1                         ; syscall: write
        syscall
        test rax, rax                      ; Check for errors
        js  exit_error                     ; If error, exit

        jmp lexer_done                     ; Jump to the end of the lexer

        lexer_next_char:
            inc rsi                        ; Move to the next character
            jmp lexer_loop

    lexer_done:
    ret

copy_string:
    ; Copy a null-terminated string from rsi to rdi
    ; Assumes rdi is a buffer that has enough space to accommodate the string

    ; Reset lexeme length
    mov qword [lexeme_length], 0

    ; Loop to copy the string
    copy_string_loop:
        mov al, [rsi]               ; Load the byte at the source address
        cmp al, 0                   ; Check for null terminator
        je copy_string_done         ; If null terminator, exit the loop
        mov [rdi], al               ; Copy the byte to the destination address
        inc rsi                     ; Move to the next character in the source
        inc rdi                     ; Move to the next character in the destination
        inc qword [lexeme_length]   ; Increment lexeme length
        jmp copy_string_loop        ; Repeat the loop

    copy_string_done:
    ret

exit_error:
    ; Handle error (you can add error message or additional actions here)
    mov rdi, 1                      ; File descriptor: STDOUT
    mov rsi, err_msg                ; Buffer address
    mov rdx, err_msg_len            ; Number of bytes to write
    mov rax, 1                      ; syscall: write
    syscall

    mov rax, 60                     ; syscall: exit
    xor rdi, 1                      ; exit code 1 (error)
    syscall
    ret

print:
    ; Print a string
    ; Function to print a string with a specified size
    ; Parameters: rdi - address of the string, rsi - size of the string
    mov rsi, rdi
    mov rdx, rsi            ; size of the string
    mov rdi, 1              ; file descriptor: STDOUT (1)

    mov rax, 1              ; syscall: write
    syscall