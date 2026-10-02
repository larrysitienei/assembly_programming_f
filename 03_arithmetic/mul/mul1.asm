section .text
    global _start

_start:
    mov rax, 5
    mov rbx, 3
    mul rbx

    mov rax, 60
    mov rdi, 0
    syscall
