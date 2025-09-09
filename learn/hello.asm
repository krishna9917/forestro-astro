section .data
    hello_msg db 'Hello, World!', 0   ; Define a null-terminated string
    
section .text
    global _start                     ; Entry point for the program

_start:
    ; Write syscall (sys_write)
    mov eax, 4                        ; System call number for sys_write
    mov ebx, 1                        ; File descriptor (1 = stdout)
    mov ecx, hello_msg                ; Pointer to the message
    mov edx, 13                       ; Message length in bytes
    int 0x80                          ; Call kernel
    
    ; Exit syscall (sys_exit)
    mov eax, 1                        ; System call number for sys_exit
    xor ebx, ebx                      ; Exit status (0 = success)
    int 0x80                          ; Call kernel
