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
        je done
        int 0x10
        jmp .print_loop

print_attr:
    mov byte [color_x], 0
    .print_attr_loop:
        lodsb
        cmp al, 0
        je done

        mov ah, 0x02
        mov bh, 0
        mov dh, 0
        mov dl, [color_x]
        int 0x10

        mov ah, 0x09
        mov bh, 0
        mov cx, 1
        int 0x10

        inc byte [color_x]

        jmp .print_attr_loop

done:
    ret

;---------------------------
cmp_str:
    push si
    push di
    push ax
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

.end:
    pop bx
    pop ax
    pop di
    pop si
    ret
;---------------------------

color_x db 0