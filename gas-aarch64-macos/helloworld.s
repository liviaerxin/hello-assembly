// Assembler program to print "Hello World!" to stdout.
/* 
as -arch arm64 -o helloworld.o helloworld.asm && ld -e _start helloworld.o && ./a.out

as -arch arm64 -o helloworld.o helloworld.asm \
&& ld -o helloworld helloworld.o \
	-lSystem \
	-syslibroot `xcrun -sdk macosx --show-sdk-path` \
	-e _start \
	-arch arm64 \
&& ./helloworld
*/

.data
    message: .ascii  "Hello World!\n"
    message_size = . - message

.text
    .global _start			// Provide program starting address to linker
    .align 4			    // Make sure everything is aligned properly

_start:
    // Print "Hello, World!" to the console
    mov	    X0, #1		            // File descriptor: STDOUT (1)
	adrp	X1, message@PAGE 	    // Pointer to the string
    add     X1, X1, message@PAGEOFF // Pointer to the string
	mov	    X2, message_size        // Length of the string
	mov	    X16, #4		            // System call number for write
	svc	    #0		                // Invoke the system call

    // Exit the program
	mov     X0, #0		// Exit code 0
	mov     X16, #1		// System call number for exit
	svc     #0		    // Invoke the system call