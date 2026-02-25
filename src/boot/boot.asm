bits 16
org 0x7C00 ; Memory offset address of the bootloader (0x0000 physical)

; Segment * 16 + offset = ?

start:
    ; STACK SETUP
    cli     ; Disable interrupts // touch stack freely

    mov ax, 0x9000  ; Free AX to then sent values into SS
    mov ss, ax      ; Set SS to memory 0x9000
    mov sp, 0xFFFF  ; Set SP to memory 0xFFFF

    xor ax, ax
    mov ds, ax  ; Set Data Segment to 0x0000 (physical address of bootloader)
    mov es, ax  ; Set Extra Segment to 0x0000

    sti     ; Enable interrupts

    ; SCREEN SETUP
    mov ax, 0x0003  ; Set screen in 80x25 with 8x8 font
    int 0x10 ; Set video mode in BIOS interrupt (also resets the screen)

; The magic numbers frfr
times 510 - ($ - $$) db 0
dw 0xAA55