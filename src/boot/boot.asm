bits 16
org 0x7C00

start:
    ; STACK SETUP
    cli ; disable interrupts
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF
    sti ; enable interrupts

    ; Aller sur 0x1000 pour écrire
    mov ax, 0x1000  ; Écrire sur physical address disk
    mov es, ax
    mov bx, 0

    ; Kernel Loading
    mov al, 1       ; Read 1 Sector
    mov ah, 0x02    ; Read
    mov ch, 0       ; Cylinder 0
    mov cl, 2       ; Start at sector 2
    mov dh, 0
    mov dl, 0x80    ; First drive
    int 0x13        ; Disk interrupts

    jc disk_error   ; Carry Flag
    jmp 0x1000:0x0000

disk_error:
    cli
.hlt:
    hlt
    jmp .hlt

; magic formula for 512 bits
times 510 - ($ - $$) db 0
dw 0xAA55