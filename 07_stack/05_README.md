# 05.asm — 64-bit Hexadecimal Stack Operations

## 1. Introduction

This program demonstrates how the x86-64 stack stores and retrieves hexadecimal values.

It uses 64-bit registers and shows how PUSH and POP preserve values while following the Last In, First Out (LIFO) principle.

## 2. Execution Flow

Execution begins at `_start`.

```asm
mov rax, 0x1122334455667788
mov rbx, 0x1234
push rax
push rbx
nop
pop rbx
pop rax
mov rax, 60
xor rdi, rdi
syscall
```

RAX is loaded with the 64-bit hexadecimal value `0x1122334455667788`.

RBX receives `0x1234`.

PUSH RAX saves the full 64-bit value onto the stack.

PUSH RBX saves `0x1234` as an eight-byte stack entry, making it the new top value.

NOP performs no operation.

POP RBX retrieves `0x1234`.

POP RAX retrieves `0x1122334455667788`.

The program then invokes the Linux exit system call with status 0.

## 3. Stack Pointer Changes

The following addresses were observed using GDB.

| Instruction | RSP Before | RSP After |
|---|---|---|
| mov rax, value | 0x7fffffffd9e0 | 0x7fffffffd9e0 |
| mov rbx, value | 0x7fffffffd9e0 | 0x7fffffffd9e0 |
| push rax | 0x7fffffffd9e0 | 0x7fffffffd9d8 |
| push rbx | 0x7fffffffd9d8 | 0x7fffffffd9d0 |
| nop | 0x7fffffffd9d0 | 0x7fffffffd9d0 |
| pop rbx | 0x7fffffffd9d0 | 0x7fffffffd9d8 |
| pop rax | 0x7fffffffd9d8 | 0x7fffffffd9e0 |

## 4. Stack Contents

After PUSH RAX:

```text
0x7fffffffd9d8: 0x1122334455667788
```

After PUSH RBX:

```text
0x7fffffffd9d0: 0x0000000000001234
0x7fffffffd9d8: 0x1122334455667788
```

The smaller hexadecimal value still occupies an eight-byte stack entry because the instruction pushes a 64-bit register.

After POP RBX, the top active stack entry contains the original RAX value.

After POP RAX, the stack pointer returns to its initial position.

POP changes the active stack boundary; it does not necessarily overwrite the memory holding the popped value.

## 5. GDB Observations

The initial RSP was:

`0x7fffffffd9e0`

After the first PUSH, RSP decreased to:

`0x7fffffffd9d8`

After the second PUSH, RSP decreased to:

`0x7fffffffd9d0`

GDB confirmed both hexadecimal values in stack memory.

After executing the two POP instructions, the original register values were restored.

The final RSP was:

`0x7fffffffd9e0`

This confirmed that both PUSH operations were balanced by corresponding POP operations.

## 6. Program Output

The program prints no terminal text.

Its recorded execution exit status was 0.

The debugger traced the stack operations successfully and stopped before the exit sequence completed.

## 7. Conclusion

This program demonstrates how 64-bit hexadecimal values are stored on the stack.

Each PUSH decreases RSP by eight bytes, regardless of whether the register contains a small or large numerical value.

Each POP increases RSP by eight bytes.

The debugging results demonstrate LIFO behavior and show that the original stack pointer is restored.
