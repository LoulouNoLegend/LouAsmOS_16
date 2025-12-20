newline_tty:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

read_key:
    mov ah, 0x00
    int 0x16
    ret

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

;---------------------------
print_tty:
    mov ah, 0x0E
    .print_loop:
        lodsb
        cmp al, 0
        je .done
        int 0x10
        jmp .print_loop
    .done:
        ret

print_attr:
    push ax
    push bx
    push cx
    push dx
    push bp
    push di
    push es

    mov di, si
    xor cx, cx

    .len:
        cmp byte [di], 0
        je .go
        inc di
        inc cx
        jmp .len

    .go:
        mov ax, ds
        mov es, ax
        mov bp, si

        mov ah, 0x13
        mov al, 0x01
        mov bh, 0x00
        int 0x10

        pop es
        pop di
        pop bp
        pop dx
        pop cx
        pop bx
        pop ax
        ret

;---------------------------
cmp_str:
    push si
    push di
    push bx
.cmp_loop:
    mov al, [si]    ; AL = char string 1
    mov bl, [di]    ; BL = Char string 2

    cmp al, bl
    jne .not_equal

    cmp al, 0
    je .equal

    inc si
    inc di
    jmp .cmp_loop

.equal:
    mov al, 1
    jmp .end

.not_equal:
    mov al, 0
    jmp .end

.end:
    pop bx
    pop di
    pop si
    ret
;---------------------------

color_x db 0