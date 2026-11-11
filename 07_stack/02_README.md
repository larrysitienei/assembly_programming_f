# 02.asm — Stack Frame and Local Variables Analysis

## 1. Introduction

This program demonstrates how a stack frame is created, used, and destroyed during a function call in 64-bit x86 assembly.

The program uses the RSP and RBP registers to manage stack memory. It demonstrates how a function saves its caller's frame pointer, allocates space for local variables, accesses those variables, and restores the stack before returning.

## 2. Program Execution Flow

Execution begins at the `_start` label.

The first instruction is:

```asm
call work
```

This instruction calls the `work` function. Before transferring control, the CPU pushes the return address onto the stack.

Inside the function, the following instructions execute:

```asm
push rbp
mov rbp, rsp
sub rsp, 16
```

The `push rbp` instruction saves the previous frame pointer.

The `mov rbp, rsp` instruction establishes a new stack frame.

The `sub rsp, 16` instruction reserves 16 bytes for two local variables.

The program then stores:

```asm
mov qword [rbp - 8], 100
mov qword [rbp - 16], 200
```

These instructions store the values 100 and 200 in the allocated stack memory.

The values are retrieved using:

```asm
mov rax, [rbp - 8]
mov rbx, [rbp - 16]
```

GDB confirmed that RAX received 100 and RBX received 200.

The function then restores the stack using:

```asm
mov rsp, rbp
pop rbp
ret
```

Execution returns to `_start`, where the program terminates using the Linux exit system call.

## 3. Stack Operations

### CALL Instruction

The `call work` instruction saves the return address on the stack.

Before execution:

RSP = `0x7fffffffd9e0`

After execution:

RSP = `0x7fffffffd9d8`

The return address stored on the stack was:

`0x0000000000401005`

This confirms that CALL decreases RSP by 8 bytes in 64-bit mode.

### PUSH RBP

The instruction:

```asm
push rbp
```

saves the previous frame pointer.

RSP decreases from:

`0x7fffffffd9d8`

to:

`0x7fffffffd9d0`

The previous value of RBP was 0 in this debugging session.

### Establishing the Stack Frame

The instruction:

```asm
mov rbp, rsp
```

sets RBP equal to RSP.

Both registers then contain:

`0x7fffffffd9d0`

RBP acts as a stable reference point for accessing local variables.

### Allocating Local Memory

The instruction:

```asm
sub rsp, 16
```

decreases RSP by 16 bytes.

RSP changes to:

`0x7fffffffd9c0`

The reserved memory contains two 8-byte local variables.

### Storing Local Variables

The first local variable is stored at:

`[rbp-8] = 100`

The second local variable is stored at:

`[rbp-16] = 200`

GDB confirmed the values:

```text
0x7fffffffd9c0: 200  100
```

### Retrieving Local Variables

The instructions:

```asm
mov rax, [rbp - 8]
mov rbx, [rbp - 16]
```

load the stored values into registers.

GDB confirmed:

- RAX = 100
- RBX = 200

These instructions do not change RSP because they read existing stack memory rather than pushing or popping values.

### Restoring the Stack

The instruction:

```asm
mov rsp, rbp
```

restores RSP to:

`0x7fffffffd9d0`

This releases the 16-byte local-variable area from the active stack frame.

Next:

```asm
pop rbp
```

restores the previous frame pointer.

RSP increases to:

`0x7fffffffd9d8`

Finally:

```asm
ret
```

retrieves the saved return address.

RSP returns to:

`0x7fffffffd9e0`

Execution resumes in the calling program.

## 4. Stack Pointer Changes

The following values were recorded using GDB.

| Instruction | RSP Before | RSP After |
|---|---|---|
| `call work` | 0x7fffffffd9e0 | 0x7fffffffd9d8 |
| `push rbp` | 0x7fffffffd9d8 | 0x7fffffffd9d0 |
| `mov rbp, rsp` | 0x7fffffffd9d0 | 0x7fffffffd9d0 |
| `sub rsp, 16` | 0x7fffffffd9d0 | 0x7fffffffd9c0 |
| Store local variables | 0x7fffffffd9c0 | 0x7fffffffd9c0 |
| Load local variables | 0x7fffffffd9c0 | 0x7fffffffd9c0 |
| `mov rsp, rbp` | 0x7fffffffd9c0 | 0x7fffffffd9d0 |
| `pop rbp` | 0x7fffffffd9d0 | 0x7fffffffd9d8 |
| `ret` | 0x7fffffffd9d8 | 0x7fffffffd9e0 |

## 5. GDB Debugging Observations

The program was debugged using GNU Debugger (GDB).

Commands used included:

```gdb
break _start
run
info registers rsp rbp
x/10i $rip
si
x/gx $rsp
x/gd $rbp-8
x/gd $rbp-16
info registers rax
info registers rbx
```

### Observation 1: Function Call

The return address `0x401005` was pushed onto the stack.

### Observation 2: Stack Frame Creation

RBP was set to `0x7fffffffd9d0`, providing a stable reference point for the local variables.

### Observation 3: Local Variable Allocation

RSP decreased by 16 bytes, reserving memory for two 64-bit values.

### Observation 4: Local Variable Storage

GDB confirmed that the values 100 and 200 were stored at the expected stack addresses.

### Observation 5: Register Values

The program loaded 100 into RAX and 200 into RBX.

### Observation 6: Stack Restoration

The function restored RSP, recovered the previous RBP, and returned to the caller.

The final RSP value matched the initial value.

### Observation 7: Program Termination

GDB displayed:

```text
[Inferior 1 (process 86275) exited normally]
```

The program produced no terminal text because it does not contain instructions for printing output.

## 6. Conclusion

This program demonstrates how a function manages its own stack frame.

The CALL instruction pushes a return address, while PUSH RBP saves the previous frame pointer.

The function allocates 16 bytes of local storage using `sub rsp, 16`, and RBP provides a stable reference point for accessing the stored values.

Before returning, the program releases its local storage, restores the previous frame pointer, and retrieves the return address using RET.

The debugging results confirm that the stack is essential for managing local variables, preserving execution context, and returning correctly from functions.