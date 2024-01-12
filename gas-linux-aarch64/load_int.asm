// Load 32-bit integer
// aarch64-linux-gnu-as -o load_int.o load_int.asm && aarch64-linux-gnu-ld load_int.o && ./a.out
// echo $?
.data
    expected_value: .word  0x1a2b3c4d

.text
    .global _start

_start:
    b fail_label
    // Load the 32-bit integer `0x1a2b3c4d` into the eax register
    mov x1, 0x3c4d              // Set the lower 8 bits
    movk x1, 0x1a2b, lsl 16
    
    //Assert
    ldr x2, =expected_value
    cmp x1, x2              // 
    b.eq success_label           //
    b.ne fail_label              //

success_label:
    // Exit the program
    mov x0, #0              // exit code: 0
    mov x8, #93             // syscall: exit
    svc 0

fail_label:
    // Exit the program
    mov x0, #1              // exit code: 0
    mov x8, #93             // syscall: exit
    svc 0
