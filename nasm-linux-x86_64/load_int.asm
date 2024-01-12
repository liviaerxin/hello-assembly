; Load 32-bit integer
; nasm -f elf64 load_int.asm && ld load_int.o && ./a.out
; echo $?

section .text
    global _start

_start:
    mov eax, DWORD 0x1a2b3c4d  ; Load the 32-bit integer into the eax register

    ; Assert
    cmp eax, DWORD 0x1a2b3c4d   ;
    je success_label            ;
    jne fail_label              ;

success_label:
    ; Exit the program
    mov rdi, 0              ; exit code: 0
    mov rax, 60             ; syscall: exit
    syscall

fail_label:
    ; Exit the program
    mov rdi, 1              ; exit code: 1
    mov rax, 60             ; syscall: exit
    syscall