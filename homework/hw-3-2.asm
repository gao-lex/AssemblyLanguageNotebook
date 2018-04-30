assume cs:code,ds:data

data segment
    db 184,0,76,205,33
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,od
    mov es,ax
    mov bx,0
    mov cx,6
s:
    mov al,[bx]
    mov es:[bx],al
    inc bx
    loop s

od segment
    db 0,0,0,0,0
od ends

end start