; LAOS Micro-OS v0
; One boot sector "OS"
;   - Screen Clears
;   - Tiny menu
;   - Waits for keys
;   - React to 1 & 2

bits 16
org 0x7c00

start:
    ; Basic Segment + stack setup (for safety)
    cli         ; Clear interrupt flag / Disable hardware interrupts
    xor ax, ax  ; ax = 0
    mov ds, ax  ; Set Data Segment to 0x0000 (interpret everything at physical address)
    mov es, ax  ; Set Extra Segment to 0x0000
    mov ss, ax  ; Set Stack Segment to 0x0000
    mov sp, 0x7C00  ; Set Stack Pointer to 0x7C00
    sti         ; Enable hardware interrupts again

    ; Remember the boot drive
    mov [boot_drive], dl

main_menu:    
    call clear_screen

    ; Reset cursor to top-left
    mov ah, 0x02
    mov bh, 0       ; Page 0
    mov dh, 0       ; Row 0
    mov dl, 0       ; Col 0
    int 0x10

    mov si, msg_title
    mov bl, 0x09
    call print_attr
    
    call newline_tty
    mov si, msg_opt1
    call print_tty
    
    call newline_tty
    mov si, msg_opt2
    call print_tty

    call newline_tty
    mov si, msg_opt3
    call print_tty
    
    call newline_tty
    call newline_tty
    mov si, msg_prompt
    call print_tty

    call read_key

    cmp al, '1'
    je launch_kernel

    cmp al, '2'
    je show_about

    cmp al, '3'
    je show_halt
    
    jmp main_menu

;---------------------------
; Load kernel from disk into 0x1000:0000
launch_kernel:
    ; Set ES = 0x1000 (segment)
    mov ax, 0x1000
    mov es, ax
    xor bx, bx          ; offset 0

    ; Read 1 sector from CHS(0,0,2) -> LBA(1)
    ; LBA 0 -> CHS(0,0,1) -> Boot.bin
    ; LBA 1 -> CHS(0,0,2) -> Kernel.bin
    mov ah, 0x02        ; BIOS: read sectors
    mov al, 1           ; number of sectors to read = 1
    mov ch, 0           ; cylinder 0
    mov cl, 2           ; sector 2 (boot is sector 1)
    mov dh, 0           ; head 0
    mov dl, [boot_drive]
    int 0x13

    jc disk_error       ; if CF=1, error

    ; If there's no error then jump to kernel (0x1000:0000)
    jmp 0x1000:0x0000

disk_error:
    call clear_screen
    mov si, msg_disk_err
    mov bl, 0x0C
    call print_attr
    jmp $

;---------------------------
show_about:
    call clear_screen

    mov si, msg_about
    call print_tty

    call newline_tty
    call newline_tty
    mov si, msg_anykey
    call print_tty

    ; wait for key and go back to menu
    call read_key
    jmp main_menu

show_halt:
    call clear_screen

    mov si, msg_halt
    mov bl, 0x0A
    call print_attr

    jmp $   ; freeze forever aaaa
;----------------------------

%include "src/common/functions.asm"

msg_title  db "LAOS Bootloader", 0
msg_opt1   db "[1] Launch Kernel", 0
msg_opt2   db "[2] About", 0
msg_opt3   db "[3] Halt system", 0
msg_prompt db "Select option: ", 0

msg_about  db "LAOS is a tiny bootloader OS experiment.", 0
msg_anykey db "Press any key to return to menu.", 0

msg_halt   db "System halted. You can turn off the machine now.", 0
msg_disk_err db "Disk read error while loading kernel.", 0

boot_drive   db 0

; Placing 510 zeros, minus the size of the code above
;   then boot signature / magic number (16-bit / 2 bytes)
times 510 - ($-$$) db 0
dw 0xaa55