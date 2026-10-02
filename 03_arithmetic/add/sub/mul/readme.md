# MUL — Multiplication

## Overview

This directory contains two x86-64 assembly programs demonstrating unsigned multiplication using the `MUL` instruction.

The programs are:

- `mul1.asm` — multiplies 5 by 3.
- `mul2.asm` — multiplies 10 by 20.

The `MUL` instruction multiplies the value in `RAX` by the specified operand. For 64-bit multiplication, the full result is stored in `RDX:RAX`.

---

## mul1.asm

### Operation

The program performs:

```text
5 × 3 = 15