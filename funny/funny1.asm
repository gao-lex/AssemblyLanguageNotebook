assume cs:code,ds:data,ss:stack

data segment
    db '1       *       '
    db '2      ***      '
    db '3     *****     '
    db '4    *******    '
    db '5   *********   '
    db '6  ***********  '
    db '7 ************* '
data ends

stack segment
    dw 0,0,0,0,0,0,0,0
stack ends

code segment
start:
    ;数据段
    mov ax,data
    mov ds,ax

    mov ax,stack
    mov ss,ax
    mov sp,16

    ;显存
    mov ax,0b872h
    mov es,ax

    mov bx,0
    mov bp,0

    mov ah,03
    mov cx,7

s:
    push cx
    mov si,0
    mov cx,16
    mov di,0
s0:
    mov al,ds:[bx+si]
    mov es:[bp+di],ax
    inc si
    add di,2
    loop s0
    pop cx
    add bx,16
    add bp,160
    loop s

    mov ax,4c00h
    int 21h

code ends
end start