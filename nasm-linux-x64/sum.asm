; tiny.asm
; nasm -f elf64 tiny.asm
; ld tiny.o
; ./a.out
;  objdump -d a.out

global _start

section .text

; Function to calculate the sum of two integers
sum:
    mov rax, rdi   ; Move the first argument (a) to rax
    add rax, rsi   ; Add the second argument (b) to rax
    ret            ; Return with the result in rax

_start:
    ; Example usage of the sum function
    mov rdi, 5     ; First argument: a = 5
    mov rsi, 7     ; Second argument: b = 7

    call sum       ; Call the sum function

    ; The result is now in rax
    ; It can be used or printed, depending on the context
    mov rdi, rax   ; Exit code 0

    ; Exit the program
    mov rax, 60    ; System call number for sys_exit
    syscall        ; Make the system call