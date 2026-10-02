section .text
    global _start

_start:
    mov rax, 10
    mov rbx, 3
    sub rax, rbx

    mov rax, 60
    mov rdi, 0
    syscall
