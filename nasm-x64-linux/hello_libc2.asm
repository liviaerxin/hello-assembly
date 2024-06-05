; hello_lic2.asm: print message by calling Standard C function `printf` without `main()` framework
; nasm -f elf64 hello_libc2.asm && ld hello_libc2.o -lc -I/lib64/ld-linux-x86-64.so.2 && ./a.out ; echo  "exit code:" $?

;
; CONSTANTS
;
SYS_WRITE   equ 1
SYS_EXIT    equ 60
STDOUT      equ 1

global _start

extern printf

;
; Initialised data goes here
;
SECTION .data
data           db  "Hello World!", 10   ; const char *
data_len       equ $-data           ; size_t


;
; Code goes here
;
SECTION .text

_start:
    ; printf(data) - data_len;
    lea     rdi, [data]
    call    printf
    sub     rax, data_len

    ; syscall(SYS_EXIT, rax - data_len)
    push    rax
    mov     rax, SYS_EXIT
    pop     rdi
    syscall