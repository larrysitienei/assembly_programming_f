# 06.asm — 32-bit Hexadecimal Stack Operations

## 1. Introduction

This program demonstrates stack operations in 32-bit x86 assembly.

It uses the EAX and EBX registers, with ESP acting as the stack pointer.

The main objective is to show how hexadecimal values are pushed and popped using four-byte stack entries.

## 2. Execution Flow

Execution begins at `_start`.

```asm
mov eax, 0x11223344
mov ebx, 0x1234
push eax
push ebx
nop
pop ebx
pop eax
mov eax, 1
xor ebx, ebx
int 0x80
```

First, EAX receives `0x11223344`.

EBX receives `0x1234`.

PUSH EAX decreases ESP by four bytes and stores the value of EAX on the stack.

PUSH EBX decreases ESP by another four bytes and stores `0x1234`.

NOP performs no operation.

POP EBX retrieves `0x1234` and increases ESP by four bytes.

POP EAX retrieves `0x11223344` and increases ESP by another four bytes.

The final instructions invoke the 32-bit Linux exit system call with exit status 0.

## 3. ESP Changes

GDB recorded the following addresses:

| Instruction | ESP Before | ESP After |
|---|---|---|
| mov eax, value | 0xffffcbb0 | 0xffffcbb0 |
| mov ebx, value | 0xffffcbb0 | 0xffffcbb0 |
| push eax | 0xffffcbb0 | 0xffffcbac |
| push ebx | 0xffffcbac | 0xffffcba8 |
| nop | 0xffffcba8 | 0xffffcba8 |
| pop ebx | 0xffffcba8 | 0xffffcbac |
| pop eax | 0xffffcbac | 0xffffcbb0 |

## 4. Stack Contents

After PUSH EAX:

```text
0xffffcbac: 0x11223344
```

After PUSH EBX:

```text
0xffffcba8: 0x00001234
0xffffcbac: 0x11223344
```

The last value pushed, `0x1234`, is at the top of the stack.

POP EBX retrieves this value first.

POP EAX then retrieves the previously pushed value, `0x11223344`.

This demonstrates Last In, First Out behavior.

## 5. GDB Observations

The initial ESP value was:

`0xffffcbb0`

After PUSH EAX, ESP decreased to:

`0xffffcbac`

The top value was:

`0x11223344`

After PUSH EBX, ESP decreased to:

`0xffffcba8`

GDB displayed:

```text
0xffffcba8: 0x00001234  0x11223344
```

After POP EBX, ESP increased to:

`0xffffcbac`

After POP EAX, ESP returned to:

`0xffffcbb0`

These results show that each 32-bit stack operation changed ESP by four bytes.

The two POP operations restored the values to their original registers.

## 6. Comparison with 64-bit Stack Operations

The main difference between this program and 05.asm is the stack-entry size.

In 05.asm, PUSH and POP operate on 64-bit registers and change RSP by eight bytes.

In 06.asm, PUSH and POP operate on 32-bit registers and change ESP by four bytes.

Both programs demonstrate LIFO behavior.

## 7. Program Output

The program prints no terminal text.

It was assembled using ELF32 and linked using the i386 linker mode.

The recorded execution exit status was 0.

The automated GDB log confirmed that ESP returned to its initial value.

## 8. Conclusion

This program demonstrates hexadecimal stack operations in 32-bit assembly.

Each PUSH decreases ESP by four bytes, while each POP increases ESP by four bytes.

The values are retrieved in reverse order, demonstrating LIFO behavior.

The final ESP matches the initial value, confirming that the stack operations are balanced.
