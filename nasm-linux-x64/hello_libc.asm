; hello_lic.asm: print message by calling Standard C function `printf` in `main()` framework of Standard C library
; nasm -f elf64 hello_libc.asm && gcc -no-pie hello_libc.o && ./a.out ; echo  "exit code:" $?


;
; Initialised data goes here
;
SECTION .data
data           db  "Hello World!", 10   ; const char *
data_len       equ $-data               ; size_t


;
; Code goes here
;
SECTION .text

global main

extern printf ; Declare printf as an external function

; int main ()
main:
    sub     rsp, 8               ; Align the stack (adjust as needed)
    ; Call printf(data) - return data_len;
    lea     rdi, [data]
    call    printf

    add     rsp, 8               ; Restore the stack
    sub     rax, data_len
    ret