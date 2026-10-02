section .text
    global _start

_start:
    mov rax, 20
    xor rdx, rdx
    mov rbx, 5
    div rbx

    mov rax, 60
    mov rdi, 0
    syscall
