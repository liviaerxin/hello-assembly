# Get all source files with a .asm file extension
SOURCES = $(wildcard *.asm)

# Replace .c with .o for object files
OBJECTS = $(SOURCES:.asm=.o)

# Define the executables based on the source files
EXECUTABLES = $(SOURCES:.asm=.out)

all: $(EXECUTABLES)

# Rule to build each executable
%.out: %.o
	ld $< -o $@

hello_libc2.out: hello_libc2.o
	ld -lc -I/lib64/ld-linux-x86-64.so.2 $< -o $@

hello_libc.out: hello_libc.o
	gcc -no-pie $< -o $@

# Rule to build object files
%.o: %.asm
	nasm -f elf64 $< -o $@

clean:
	rm -f $(OBJECTS) $(EXECUTABLES)