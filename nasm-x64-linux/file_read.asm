;nasm -f elf64 file_read.asm && ld file_read.o && ./a.out
section .data
    filename db 'output.txt', 0    ; Name of the input file
    buffer_size equ 1024            ; Buffer size for reading file content

section .bss
    buffer resb buffer_size         ; Buffer to store file content

section .text
    global _start

_start:
    ; Open the file
    mov rdi, filename               ; Filename
    mov rsi, 0                      ; Flags: O_RDONLY
    mov rdx, 0                      ; Mode: 0 (ignored when opening an existing file)
    mov rax, 2                      ; syscall: open
    syscall
    test rax, rax                   ; Check for errors
    js  exit_error                   ; If error, exit

    ; Read file content
    mov rdi, rax                     ; File descriptor
    mov rsi, buffer                 ; Buffer address
    mov rdx, buffer_size            ; Number of bytes to read
    mov rax, 0                      ; syscall: read
    syscall
    test rax, rax                   ; Check for errors
    js  exit_error                   ; If error, exit

    ; Print file content
    mov rdi, 1                      ; File descriptor: STDOUT
    mov rsi, buffer                 ; Buffer address
    mov rdx, rax                    ; Number of bytes to write
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
