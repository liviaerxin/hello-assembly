;nasm -f elf64 print_string.asm && ld print_string.o && ./a.out
section .data
    data            db  "Hello World!", 10     ; note `10` the newline at the end
    data_size       equ $-data                 ; size_t

section .text
    global _start

_start:
    ; Call the print function
    mov rdi, data
    mov rcx, data_size

    call print

    ; Exit the program
    call exit

print:
    ; Function to print a string with a specified size
    ; Parameters: rdi - address of the string, rcx - size of the string
    mov rsi, rdi
    mov rdx, rcx  ; size of the string
    mov rdi, 1    ; file descriptor: STDOUT (1)
    
    mov rax, 1    ; syscall: write
    syscall
    ret

exit:
    mov rax, 60             ; syscall: exit
    xor rdi, rdi            ; exit code 0 
    syscall
    ret

exit_error:
    ; Handle error (you can add error message or additional actions here)
    mov rax, 60           ; syscall: exit
    xor rdi, 1            ; exit code 1 (error)
    syscall
    ret
