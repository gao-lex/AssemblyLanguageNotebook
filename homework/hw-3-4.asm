assume cs:code
data segment
    db 'HeBEInOnGYedAxUeDAAsSemBLylaNGuAGE';34个字节
data ends

stack segment
    db 0
stack ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov cx,34
    mov ax,stack
    mov ss,ax
    mov bx,0
    mov ah,0
s:
    mov al,ds:[bx]
    and al,00100000b;如果al是大写的，这步之后al为0,小写的话,al为32(20h)
    push cx
    mov cx,ax
    jcxz tl
    jcxz tu
tu:  
    mov al,ds:[bx]
    and al,11011111B;
    mov ds:[bx],al
    inc bx
    pop cx
    loop s
tl:
    mov al,ds:[bx]
    or al,00100000b;
    mov ds:[bx],al
    inc bx
    pop cx
    loop s
    mov ax,4c00h
    int 21h
code ends
end start