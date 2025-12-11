; LAOS kernel v0
; Loaded at 0x1000:0000 by bootloader

bits 16
org 0x0000

kernel_start:
    ; Reset the stack and all
    cli
    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFF0  ; Simple stack inside the segment
    sti

    call clear_screen

    ; Reset cursor and print text
    mov ah, 0x02
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 0x10

    mov si, msg_title
    mov bl, 0x09
    call print_attr

    call newline_tty
    call newline_tty

    call cmd_loop

hang:
    jmp hang

;---------------------------
;---------------------------

%include "src/common/functions.asm"
;%include "src/kernel/memory/mem_info.asm"
%include "src/kernel/cmd/cmd_main.asm"

msg_title  db "LAOS Kernel", 0
msg_is_running db "LAOS kernel is now running!", 0

;times 512 - ($ - $$) db 0