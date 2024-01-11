; nasm -f elf64 file_write.asm && ld file_write.o && ./a.out

section .data
    filename db 'output.txt', 0    ; Name of the output file
    message db 'Hello, World!', 10, 0   ; Message to write to the file with newline

section .text
    global _start

_start:
    ; Calculate the length of the message
    mov rsi, message                ; Pointer to the message
    xor rcx, rcx                    ; Counter
find_message_length:
    cmp byte [rsi + rcx], 0        ; Check for null terminator
    je  end_find_message_length     ; If null terminator, end
    inc rcx
    jmp find_message_length
end_find_message_length:
    mov [message_len], rcx          ; Store the length in message_len

    ; Open the file for writing (create if it doesn't exist)
    mov rdi, filename               ; Filename
    mov rax, 2                      ; syscall: open
    mov rsi, 0x201 | 0x40           ; Flags: O_WRONLY | O_CREAT
    mov rdx, 0o644                  ; Mode: 644 (rw-r--r--)
    syscall
    test rax, rax                   ; Check for errors
    js  exit_error                   ; If error, exit
    mov rdi, rax                     ; Store file descriptor in rdi

    ; Write to the file
    mov rsi, message                ; Message to write
    mov rdx, [message_len]          ; Message length
    mov rax, 1                      ; syscall: write
    syscall
    test rax, rax                   ; Check for errors
    js  exit_error                   ; If error, exit

    ; Close the file
    mov rdi, rdi                     ; File descriptor
    mov rax, 3                      ; syscall: close
    syscall
    test rax, rax                   ; Check for errors
    js  exit_error                   ; If error, exit

    ; Exit the program
    mov rax, 60                     ; syscall: exit
    xor rdi, rdi                    ; exit code 0
    syscall

exit_error:
    ; Handle error (you can add error message or additional actions here)
    mov rax, 60                     ; syscall: exit
    xor rdi, 1                      ; exit code 1 (error)
    syscall

section .bss
    message_len resq 1              ; Variable to store the length of the message



