assume cs:code,ds:data

data segment
    db 'welcome to masm!'   ;16个字节
data ends

code segment
start:
    ;数据段
    mov ax,data
    mov ds,ax

    ;显存
    mov ax,0b872h
    mov es,ax
    mov bp,0

c1:
    mov ah,00000010b;2^1=2
    jmp short s
c2:
    mov ah,00100100b;2^5+2^2=32+4=36
    add bp,160
    jmp short s
c3:
    mov ah,01110001b;
    add bp,160
    jmp short s

s:
    mov cx,16
    mov di,0
    mov bx,0
s0:
    mov al,ds:[bx]
    mov es:[bp+di],ax
    add di,2
    add bx,1
    loop s0

    add ah,-2
    mov cl,0
    mov ch,ah
    jcxz c2

    add ah,2
    add ah,-36
    mov cl,0
    mov ch,ah
    jcxz c3

    mov ax,4c00h
    int 21h
code ends

end start