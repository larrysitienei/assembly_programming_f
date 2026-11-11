# 01.asm — 64-bit PUSH and POP Stack Analysis

## 1. Introduction

This NASM x86-64 program demonstrates the Last In, First Out (LIFO) behavior of the stack. It pushes two decimal values and retrieves them in reverse order.

## 2. Execution Flow

Execution begins at `_start`.

```asm
mov rax, 100
mov rbx, 200
push rax
push rbx
nop
pop rcx
pop rdx
nop
mov rax, 60
xor rdi, rdi
syscall
```

First, RAX receives 100 and RBX receives 200. Neither MOV instruction changes RSP.

`push rax` decreases RSP by 8 bytes and stores 100 at the new top of the stack.

`push rbx` decreases RSP by another 8 bytes and stores 200 above the previously pushed value.

The NOP instruction has no effect on the stack.

`pop rcx` retrieves 200 and increases RSP by 8 bytes.

`pop rdx` retrieves 100 and increases RSP by another 8 bytes.

The final NOP changes nothing. The program then invokes the Linux x86-64 exit system call with exit status 0.

## 3. Stack Pointer Changes

The following addresses were recorded in the automated GDB session.

| Instruction | RSP Before | RSP After | Effect |
|---|---|---|---|
| mov rax, 100 | 0x7fffffffd9e0 | 0x7fffffffd9e0 | RAX = 100 |
| mov rbx, 200 | 0x7fffffffd9e0 | 0x7fffffffd9e0 | RBX = 200 |
| push rax | 0x7fffffffd9e0 | 0x7fffffffd9d8 | Push 100 |
| push rbx | 0x7fffffffd9d8 | 0x7fffffffd9d0 | Push 200 |
| nop | 0x7fffffffd9d0 | 0x7fffffffd9d0 | No effect |
| pop rcx | 0x7fffffffd9d0 | 0x7fffffffd9d8 | RCX = 200 |
| pop rdx | 0x7fffffffd9d8 | 0x7fffffffd9e0 | RDX = 100 |

## 4. GDB Observations

The program was compiled using NASM with ELF64 debugging information and linked using LD.

During debugging, the initial RSP value was `0x7fffffffd9e0`.

After the first PUSH, GDB showed:

```text
RSP = 0x7fffffffd9d8
Top value = 0x64 (100)
```

After the second PUSH, GDB showed:

```text
RSP = 0x7fffffffd9d0
Top value = 0xc8 (200)
Next value = 0x64 (100)
```

After the first POP, RSP returned to `0x7fffffffd9d8`.

After the second POP, RSP returned to `0x7fffffffd9e0`.

This confirms that both pushed values were retrieved in reverse order.

The initial value 1 at the original stack address represents the argument count supplied by Linux when the process started. It was not pushed by this program.

## 5. Program Output

The program produces no text output.

The recorded execution exit status was 0.

The automated debugger stopped tracing after identifying the exit-system-call number; successful process termination was separately verified by running the executable.

## 6. Conclusion

This program demonstrates LIFO stack behavior using PUSH and POP.

Each 64-bit PUSH decreases RSP by 8 bytes, and each POP increases RSP by 8 bytes.

Because the program performs two pushes followed by two pops, RSP returns to its original address before termination.
