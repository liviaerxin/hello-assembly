;nasm -f elf64 print.asm && ld print.o && ./a.out
section .data
    out_fmt db "%ld", 0    ; Format string for printing long integers
    newline db 10           ; ASCII code for newline character

section .bss
    num resq 1              ; Reserve space for one quad-word (8 bytes) variable

section .text
    global _start

_start:
    ; Prompt the user for input
    mov rdi, 1              ; File descriptor 1 (stdout)
    mov rax, 1              ; System call number for sys_write
    mov rsi, prompt         ; Address of the prompt string
    mov rdx, prompt_len     ; Length of the prompt string
    syscall

    ; Read an integer from the user
    mov rdi, 0              ; File descriptor 0 (stdin)
    mov rax, 0              ; System call number for sys_read
    mov rsi, num            ; Address of the variable to store the input
    mov rdx, 8              ; Number of bytes to read
    syscall

    ; Print the entered integer
    mov rdi, 1              ; File descriptor 1 (stdout)
    mov rax, 1              ; System call number for sys_write
    mov rsi, num            ; Address of the variable to print
    mov rdx, 8              ; Number of bytes to print
    syscall

    ; Print a newline character
    mov rdi, 1              ; File descriptor 1 (stdout)
    mov rax, 1              ; System call number for sys_write
    mov rsi, newline        ; Address of the newline character
    mov rdx, 1              ; Number of bytes to print
    syscall

    ; Exit the program
    mov rax, 60             ; System call number for sys_exit
    xor rdi, rdi            ; Exit code 0
    syscall

section .data
    prompt db "Enter an integer: ", 0
    prompt_len equ $ - prompt
