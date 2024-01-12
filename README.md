# Hello Assembly

An introduction to the assembly for two prevalent architectures: `aarch64` and `x86_64` across operating systems: `Linux` and `macOS`.

Sub folders breakdown:

- `gas-linux-aarch64`
  * GNU assembler(`as`) for **linux aarch64/arm64**
  * written in **arm64** syntax
- `gas-macos-aarch64`
  * GNU assembler(`as`) for **macos aarch64/arm64**(Apple Silicon)
  * written in **arm64** syntax
- `gas-linux-x86_64`
  * GNU assembler(`as`) for **linux x86_64**
  * written in **AT&T** syntax
- `nasm-linux-x86_64`
  * Netwide assembler(`nasm`) for **linux x86_64**
  * written in **Intel** syntax
- `nasm-macos-x86_64`
  * Netwide assembler(`nasm`) for **macos x86_64**(Apple Intel)
  * written in **Intel** syntax

## Filename convention

**GAS** typically uses `.s` as the extension and **NASM** uses the `.asm`

## Cross assembler

You can install the cross assembler `aarch64-linux-gnu-as` in `linux-x86_64` host via `apt install gcc-aarch64-linux-gnu` in Ubuntu.

Let's break down the components of the name `aarch64-linux-gnu-as`:

- the tool is a GNU assembler `gnu-as`
- the target architecture is `aarch64`
- the target operating system is `linux`
- the host architecture is `x86-64` implicitly as the host machine is `linux-x86_64`
- the host operating system is `linux` implicitly as the host machine is `linux-x86_64`


```sh

```

To learn assembly by having a look at the assembly code `GNU GCC` generates from `C` code.

```sh
$ echo "long foo() {return 0xaf41d32c;}" | aarch64-linux-gnu-gcc -O2 -S -o- -xc -
        .arch armv8-a
        .file   "<stdin>"
        .text
        .align  2
        .p2align 4,,11
        .global foo
        .type   foo, %function
foo:
.LFB0:
        .cfi_startproc
        mov     x0, 54060
        movk    x0, 0xaf41, lsl 16
        ret
        .cfi_endproc
.LFE0:
        .size   foo, .-foo
        .ident  "GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
        .section        .note.GNU-stack,"",@progbits
```