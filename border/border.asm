.model tiny
.code

org 100h

video_segment equ 0b800h

screen_width equ 80
screen_height equ 25

x equ 65
y equ 1
border_width equ 14
border_height equ 7

space_symbol equ 0000111100000000b
v_edge_symbol equ 0000111110111010b
h_edge_symbol equ 0000111111001101b

lu_corner_symbol equ 0000111111001001b
ru_corner_symbol equ 0000111110111011b
ll_corner_symbol equ 0000111111001000b
rl_corner_symbol equ 0000111110111100b

font_style equ 00001111b

Start:
    jmp DrawBorder

DrawBorder:
    mov ax, video_segment
    mov es, ax

    mov di, (screen_width * y + x) * 2

    mov ax, lu_corner_symbol
    stosw

    mov cx, border_width - 2
    mov ax, h_edge_symbol
    rep stosw

    mov ax, ru_corner_symbol
    stosw

    xor dx, dx
    add dx, border_height
    sub dx, 2

    inner_lines_loop:
        add di, (screen_width - border_width) * 2

        mov ax, v_edge_symbol
        stosw

        mov cx, border_width - 2
        mov ax, space_symbol
        rep stosw

        mov ax, v_edge_symbol
        stosw

        dec dx

        cmp dx, 0
        jne inner_lines_loop

    add di, (screen_width - border_width) * 2

    mov ax, ll_corner_symbol
    stosw

    mov cx, border_width - 2
    mov ax, h_edge_symbol
    rep stosw

    mov ax, rl_corner_symbol
    stosw

RegistersInfo:
    mov di, (screen_width * y + x + screen_width + 2) * 2

    ; ax zone =================================================================
    mov cx, 5
    mov si, offset ax_string
    call print

    push bx
    mov bx, ax
    call print_bx
    pop bx
    ; =========================================================================

    add di, (screen_width - 10) * 2

    ; bx zone =================================================================
    mov cx, 5
    mov si, offset bx_string
    call print

    mov bx, 8abch
    call print_bx
    ; =========================================================================

    add di, (screen_width - 10) * 2

    ; cx zone =================================================================
    mov cx, 5
    mov si, offset cx_string
    call print

    mov cx, 0deadh
    push bx
    mov bx, cx
    call print_bx
    pop bx
    ; =========================================================================

    add di, (screen_width - 10) * 2

    ; dx zone =================================================================
    mov cx, 5
    mov si, offset dx_string
    call print

    mov dx, 0beefh
    push bx
    mov bx, dx
    call print_bx
    pop bx
    ; =========================================================================

    add di, (screen_width - 10) * 2

    ; es zone =================================================================
    mov cx, 5
    mov si, offset es_string
    call print

    push bx
    mov bx, es
    call print_bx
    pop bx
    ; =========================================================================

mov ah, 4ch
int 21h

; =============================================================================
; INPUT:  cx - string length
;         si - string address
;         di - print destination
;
; OUTPUT: none
; =============================================================================
print proc
    letters_loop:
        lodsb
        stosw

        loop letters_loop

    ret
print endp

; =============================================================================
; INPUT:  al - byte
;
; OUPUT: ax - two bytes with ascii codes
; =============================================================================
byte_to_hex proc
    push bx
    push ax

    and ax, 0000000000001111b
    cmp ax, 0ah
    jae hex_letter_lower_byte

    add ax, 30h
    jmp save_lower_byte

    hex_letter_lower_byte:
        sub ax, 0ah
        add ax, 41h

    save_lower_byte:
        mov bl, al

    pop ax

    shr ax, 4
    and ax, 0000000000001111b
    cmp ax, 0ah
    jae hex_letter_higher_byte

    add ax, 30h
    jmp save_upper_byte

    hex_letter_higher_byte:
        sub ax, 0ah
        add ax, 41h
    
    save_upper_byte:
        mov bh, al
    
    mov ax, bx
    
    pop bx

    ret    
byte_to_hex endp

; =============================================================================
; INPUT:  bx
;
; OUTPUT: none
; =============================================================================
print_bx proc
    mov al, bh
    call byte_to_hex

    push ax
    mov al, ah
    mov ah, font_style
    stosw

    pop ax
    mov ah, font_style
    stosw

    mov al, bl
    call byte_to_hex

    push ax
    mov al, ah
    mov ah, font_style
    stosw

    pop ax
    mov ah, font_style
    stosw

    mov al, 'h'
    stosw

    ret
print_bx endp

ax_string: db 'ax = $'
bx_string: db 'bx = $'
cx_string: db 'cx = $'
dx_string: db 'dx = $'
es_string: db 'es = $'

end Start
