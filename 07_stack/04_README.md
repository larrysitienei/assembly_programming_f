# 04.asm — 32-bit Stack Frame Analysis

## 1. Introduction

This NASM x86 program demonstrates function calls, stack-frame allocation, local variables, and stack restoration in 32-bit mode.

It uses ESP as the stack pointer and EBP as the frame pointer.

## 2. Execution Flow

Execution begins at `_start`, which calls the `work` function.

```asm
call work
```

CALL saves the return address on the stack and transfers execution to the function.

The function begins with:

```asm
push ebp
mov ebp, esp
sub esp, 8
```

PUSH EBP saves the old frame pointer. MOV EBP, ESP establishes the new frame pointer.

SUB ESP, 8 reserves eight bytes for two four-byte local variables.

The program stores:

```asm
mov dword [ebp - 4], 100
mov dword [ebp - 8], 200
```

It retrieves these values into EAX and EBX.

After a NOP instruction, the function restores the stack:

```asm
mov esp, ebp
pop ebp
ret
```

MOV ESP, EBP releases the local-variable area.

POP EBP restores the previous frame pointer.

RET retrieves the return address and resumes execution in `_start`.

Finally, the program executes the Linux i386 exit system call using EAX = 1 and EBX = 0.

## 3. ESP Changes

The following addresses were recorded during GDB debugging.

| Instruction | ESP Before | ESP After |
|---|---|---|
| call work | 0xffffcbb0 | 0xffffcbac |
| push ebp | 0xffffcbac | 0xffffcba8 |
| mov ebp, esp | 0xffffcba8 | 0xffffcba8 |
| sub esp, 8 | 0xffffcba8 | 0xffffcba0 |
| Store local variables | 0xffffcba0 | 0xffffcba0 |
| Load local variables | 0xffffcba0 | 0xffffcba0 |
| mov esp, ebp | 0xffffcba0 | 0xffffcba8 |
| pop ebp | 0xffffcba8 | 0xffffcbac |
| ret | 0xffffcbac | 0xffffcbb0 |

## 4. Stack Frame Structure

During execution, EBP was `0xffffcba8`.

The stack contained:

```text
Address       Contents
0xffffcbb0    Original process stack
0xffffcbac    Return address: 0x08049005
0xffffcba8    Saved EBP: 0
0xffffcba4    Local variable: 100
0xffffcba0    Local variable: 200 <- ESP
```

The return address is stored by CALL.

The saved EBP allows the function to restore the caller's frame pointer.

The local variables are accessed using offsets from EBP.

## 5. GDB Observations

The program was assembled using ELF32 and linked using the i386 linker mode.

GDB confirmed that ESP initially contained:

`0xffffcbb0`

After CALL, the return address at the top of the stack was:

`0x08049005`

After PUSH EBP and stack allocation, ESP became:

`0xffffcba0`

The following commands confirmed the local variables:

```gdb
x/wd $ebp-4
x/wd $ebp-8
```

The observed values were:

```text
0xffffcba4: 100
0xffffcba0: 200
```

The function loaded the values into registers:

```text
EAX = 100
EBX = 200
```

After executing MOV ESP, EBP, ESP became `0xffffcba8`.

After POP EBP, ESP became `0xffffcbac`, and EBP was restored to 0.

After RET, ESP returned to `0xffffcbb0`.

GDB reported normal program termination.

## 6. Program Output

The program prints no terminal text.

After correct 32-bit compilation, the observed exit status was 0.

An earlier attempt to build the program as ELF64 resulted in a segmentation fault. Rebuilding it as ELF32 and linking with `ld -m elf_i386` resolved this problem.

## 7. Conclusion

The program demonstrates how 32-bit assembly functions create and remove stack frames.

CALL and PUSH each decrease ESP by four bytes.

Eight bytes are allocated for two local variables.

MOV ESP, EBP, POP EBP, and RET restore the original stack state.

The final ESP matches the initial value, confirming that the stack frame was correctly cleaned up.
