;nasm -f elf64 factorial.asm && ld factorial.o && ./a.out
section .text
    global _start

_start:
    ; Set up initial value
    mov rdi, 4   ; Compute factorial(4)
    
    ; Call the factorial function
    call factorial
    
    ; Exit the program with the result
    mov rdi, rax  ; Result of factorial(4)
    mov rax, 60   ; syscall: exit
    syscall

factorial:
    ; Function prologue
    push rbp
    mov rbp, rsp

    ; Function body
    cmp rdi, 0       ; Check if n == 0
    je  base_case    ; If true, jump to base_case
    
    ; Recursive case: n * factorial(n-1)
    dec rdi          ; Decrement n
    call factorial  ; Recursive call
    imul rax, rdi   ; Multiply result by n
    
    jmp end_factorial ; Jump to the end of the factorial function
    
base_case:
    ; Base case: return 1
    mov rax, 1
    
end_factorial:
    ; Function epilogue
    pop rbp
    ret
