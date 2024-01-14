// Load 32-bit integer
// aarch64-linux-gnu-as -o load_integers.o load_integers.s && aarch64-linux-gnu-ld load_integers.o && ./a.out
// as -o load_integers.o load_integers.s && ld load_integers.o && ./a.out
// echo $?
.data
    int8_var:   .byte   0x1a  // Align the next data item on a 4-byte boundary
.balign 4
    int16_var:   .hword   0x1a2b
.balign 4
    int32_var:  .word   0x1a2b3c4d
    int64_var:  .dword  0x1a2b3c4d1a2b3c4d
    // address_of_variable : .dword variable 
.text
    .global _start

_start:
    // Load the 64-bit integer `0x1a2b3c4d1a2b3c4d` from the immediate
    mov     x1, #0x3c4d
    movk    x1, #0x1a2b, lsl #16
    movk    x1, #0x3c4d, lsl #32
    movk    x1, #0x1a2b, lsl #48
    // Load the 64-bit integer from global variable `int64_var`
    // 1. ldr
    // ldr     x2, int64_var
    // 2. adrp+add
    adrp	x20, int64_var
    add     x20, x20, :lo12:int64_var
    ldr    x2, [x20]
    //Assert
    cmp     x1, x2              // 
    b.ne    fail_label              //

    // Load the 32-bit integer `0x1a2b3c4d` from the immedPiate
    movz    x1, #0x3c4d
    movk    x1, #0x1a2b, lsl #16
    // Load the value from global variable
    // 1. ldr
    // ldr     w2, int32_var
    // 2. adrp+add
    adrp	x20, int32_var
    add     x20, x20, :lo12:int32_var
    ldr     w2, [x20]
    // ldr x2, =0x1a2b3c4d
    //Assert
    cmp     x1, x2              // 
    b.ne    fail_label              //

    // Load the 16-bit integer `0x1a2b` from the immediate
    mov        x1, #0x1a2b
    // Load the 16-bit integer from global variable `int16_var`
    // 1. ldr addr + ldr
    // ldr x20, =int16_var
    // ldrh w2, [x20]
    // 2. adr + ldr
    // adr 	x20, int16_var 	    // Pointer to the string
    // ldrh    w2, [x20]
    // 3. adrp + add + ldr
    adrp	x20, int16_var
    add     x20, x20, :lo12:int16_var
    ldrh    w2, [x20]
    // ldrh w2, [x20,  :lo12:int16_var]
    // ldr x2, =0x1a2b
    //Assert
    cmp     x1, x2              // 
    b.ne    fail_label              //

    // Load the 8-bit integer `0x1a` from the immediate
    mov        x1, #0x1a
    // Load the 8-bit integer from global variable `int8_var`
    adrp	x20, int8_var
    add     x20, x20, :lo12:int8_var
    ldrb    w2, [x20]
    // ldr x2, =0x1a
    // Assert
    cmp     x1, x2              // 
    b.ne    fail_label              //

    b    success_label           //

success_label:
    // Print success message
    mov x0, #1                  // File descriptor: STDOUT (1)
    adr x1, success_str             // Pointer to the string
    ldr x2, =success_str_size       // Length of the string
    mov x8, #64                 // System call number for write
    svc 0

    // Exit the program
    mov     x0, #0              // exit code: 0
    mov     x8, #93             // syscall: exit
    svc     0

fail_label:
    // Print fail message
    mov x0, #1                  // File descriptor: STDOUT (1)
    adr x1, fail_str             // Pointer to the string
    ldr x2, =fail_str_size       // Length of the string
    mov x8, #64                 // System call number for write
    svc 0

    // Exit the program
    mov     x0, #1              // exit code: 1
    mov     x8, #93             // syscall: exit
    svc     0

success_str:    .ascii      "Success!\n"
success_str_size = . - success_str
fail_str:    .ascii      "Fail!\n"
fail_str_size = . - fail_str

