.data
    message: .ascii  "Hello World!\n"
    message_size = . - message      // current address - message address
    my_variable:    .quad 13

.text
    .global _start

_start:
    // Write the message to stdout
    mov x0, #1               // File descriptor: STDOUT (1)
    // ldr x1, =message         // Pointer to the string
    adr x1, message         // Pointer to the string
    ldr x2, =message_size             // Length of the string
    mov x8, #64             // System call number for write
    svc 0

    // Exit the program
    mov x0, #0              // Exit code 0
    mov x8, #93             // System call number for exit
    svc 0
