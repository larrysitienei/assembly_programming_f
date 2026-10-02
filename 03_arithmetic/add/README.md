# ADD Operations
## Program 1: add1.asm

### Operation

This program performs the following addition:

5 + 3 = 8
### EFLAGS

The relevant flags after the ADD instruction are:

- Carry Flag (CF): Cleared
- Zero Flag (ZF): Cleared
- Sign Flag (SF): Cleared
- Overflow Flag (OF): Cleared
### Explanation

**Carry Flag (CF): Cleared**

CF is cleared because 5 + 3 = 8 and the addition does not produce a
carry out of the most significant bit of the destination register.

**Zero Flag (ZF): Cleared**

ZF is cleared because the result is 8, not zero.

**Sign Flag (SF): Cleared**

SF is cleared because the result is positive. The most significant bit
of the result is 0.

**Overflow Flag (OF): Cleared**

OF is cleared because 8 is within the range that can be represented as
a signed 64-bit integer. Therefore, signed overflow does not occur.
---

## Program 2: add2.asm

### Operation

This program performs:

10 + 10 = 20
### EFLAGS

After the ADD instruction, GDB showed:

- Carry Flag (CF): Cleared
- Zero Flag (ZF): Cleared
- Sign Flag (SF): Cleared
- Overflow Flag (OF): Cleared
- Parity Flag (PF): Set
- Auxiliary Carry Flag (AF): Set
- Interrupt Flag (IF): Set

### Explanation

**Carry Flag (CF): Cleared**

CF is cleared because 10 + 10 = 20 and there is no carry out of the
most significant bit of the destination register.

**Zero Flag (ZF): Cleared**

ZF is cleared because the result is 20, not zero.

**Sign Flag (SF): Cleared**

SF is cleared because 20 is positive and the most significant bit of
the result is 0.

**Overflow Flag (OF): Cleared**

OF is cleared because 20 is within the signed 64-bit integer range.
Therefore, the addition does not cause signed overflow.

**Parity Flag (PF): Set**

PF is set because the low byte of the result 20 is:

00010100

There are two 1-bits in this byte. Since the number of 1-bits is even,
the parity flag is set.

**Auxiliary Carry Flag (AF): Set**

AF is set because the addition produces a carry from bit 3 to bit 4.

In hexadecimal:

0x0A + 0x0A = 0x14

The lower hexadecimal digit changes from A + A to 4 with a carry into
the upper hexadecimal digit, so AF is set.

**Interrupt Flag (IF): Set**

IF is set because interrupts are enabled in the processor. The ADD
instruction does not modify the Interrupt Flag.
