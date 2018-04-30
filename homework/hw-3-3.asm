assume cs:code,ds:data,ss:stack


code segment
start:
    and ax,01h
    mov cx,ax
    jcxz s1
    mov bx,1
s1:
    mov bx,0

    mov ax,4c00h
    int 21h
code ends
end start