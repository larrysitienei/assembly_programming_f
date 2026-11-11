# 03.asm — Function Calls and Stack Operations

## 1. Introduction

This program demonstrates how the stack supports function calls and returns in 64-bit x86 assembly. It uses the `CALL` and `RET` instructions to transfer execution to a function and return to the calling program.

The main purpose is to demonstrate how the CPU temporarily stores a return address on the stack so execution can resume at the correct instruction after a function finishes.

## 2. Program Execution Flow

Execution begins at the `_start` label.

The first instruction is:

```asm
mov rax, 10
```

This loads the value 10 into the RAX register without changing the stack pointer.

The next instruction is:

```asm
call calculate
```

This transfers control to the `calculate` function.

Before transferring control, the CPU pushes the address of the next instruction onto the stack. In this debugging session, the return address was `0x40100a`.

The `calculate` function contains:

```asm
calculate:
    add rax, 5
    ret
```

The `add` instruction increases RAX from 10 to 15.

The `ret` instruction retrieves the saved return address from the stack and returns execution to the `after_call` label.

The program then executes a `nop` instruction and terminates using the Linux exit system call.

## 3. Stack Operations

### CALL Instruction

When `call calculate` executes, the CPU saves the return address on the stack.

GDB showed that RSP changed from:

`0x7fffffffd9d0`

to:

`0x7fffffffd9c8`

This represents an 8-byte decrease, as expected for a near CALL instruction in 64-bit mode.

The memory at the new stack pointer contained:

`0x000000000040100a`

This was the return address that the program would use after the function completed.

### ADD Instruction

Inside the function, the instruction:

```asm
add rax, 5
```

changes RAX from 10 to 15.

This operation does not change RSP because it performs arithmetic using a register rather than pushing or popping stack values.

### RET Instruction

The function ends with:

```asm
ret
```

This instruction retrieves the return address from the stack and transfers execution back to the calling code.

GDB showed that RSP increased from:

`0x7fffffffd9c8`

to:

`0x7fffffffd9d0`

The stack pointer therefore returned to its original value.

## 4. Stack Pointer Changes

The following addresses were recorded during debugging:

| Instruction | RSP Before | RSP After | Explanation |
|---|---|---|---|
| `mov rax, 10` | 0x7fffffffd9d0 | 0x7fffffffd9d0 | Loads 10 into RAX |
| `call calculate` | 0x7fffffffd9d0 | 0x7fffffffd9c8 | Pushes return address |
| `add rax, 5` | 0x7fffffffd9c8 | 0x7fffffffd9c8 | Changes RAX to 15 |
| `ret` | 0x7fffffffd9c8 | 0x7fffffffd9d0 | Pops return address |

The stack grows toward lower memory addresses when the return address is pushed.

The RET instruction restores RSP by removing the return address from the active stack.

## 5. GDB Debugging Observations

The program was debugged using GNU Debugger (GDB).

The following commands were used:

```gdb
break _start
run
info registers rsp
x/4gx $rsp
x/i $rip
si
info registers rax
x/gx $rsp
```

### Observation 1: Initial Stack Pointer

At the beginning of execution, RSP was:

`0x7fffffffd9d0`

### Observation 2: Function Call

After executing `call calculate`, RSP decreased to:

`0x7fffffffd9c8`

The return address stored at this location was:

`0x40100a`

This confirmed that the CALL instruction saved the address needed to resume execution.

### Observation 3: Arithmetic Operation

After executing `add rax, 5`, GDB displayed:

`RAX = 0xf`

This is equivalent to decimal 15.

### Observation 4: Function Return

After executing RET, execution resumed at:

`after_call`

RSP returned to:

`0x7fffffffd9d0`

This confirmed that the return address was correctly retrieved from the stack.

### Observation 5: Program Termination

GDB displayed:

`[Inferior 1 (process 79710) exited normally]`

The program produced no terminal text because it contains no instructions for printing output.

## 6. Conclusion

This program demonstrates how the stack manages function calls and returns.

The CALL instruction pushes a return address onto the stack, causing RSP to decrease by 8 bytes.

The function performs its calculation without modifying the stack pointer.

The RET instruction pops the stored return address, restoring RSP and allowing execution to continue in the calling program.

The debugging results confirm that the stack is essential for preserving the correct flow of execution during function calls.
