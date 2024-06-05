; hello.asm: print message by using Linux system calls directly
; nasm -f elf64 hello.asm && ld hello.o && ./a.out ; echo  "exit code:" $?
; wc -c a.out
; objdump -t a.out
; strip -s a.out # remove symbol table
; The order of the registers is: rdi, rsi, rdx, r10, r8, r9
global _start

;
; CONSTANTS
;
SYS_WRITE   equ 1
SYS_EXIT    equ 60
STDOUT      equ 1

;
; Initialised data goes here
;
SECTION .data
data            db  "Hello World!", 10     ; note `10` the newline at the end
data_size       equ $-data                 ; size_t

;
; Code goes here
;
SECTION .text

_start:
    ; syscall(SYS_WRITE, STDOUT, data, data_size);
    mov     rax, SYS_WRITE          ; system call for write
    mov     rdi, STDOUT             ; file handle 1 is stdout
    ; mov     rsi, data               ; address of string to output
    lea     rsi, [data]
    mov     rdx, data_size          ; number of bytes
    syscall                         ; invoke operating system to do the write
    push    rax                     ; push syscall result to stack

    ; syscall(SYS_EXIT, <sys_write return value> - data_size);
    mov     rax, SYS_EXIT           ; system call for exit
    pop     rdi                     ; pop the top of stack rdi
    sub     rdi, data_size          ; subtract
    syscall                         ; invoke operating system to exit