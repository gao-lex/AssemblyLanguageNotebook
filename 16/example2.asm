;在code段中使用的标号a,b后面没有":"
;它们是同时描述内存地址和单元长度的标号
;我们称这种标号为数据标号
assume cs:code
code segment
    a db 1,2,3,4,5,6,7,8
    b dw 0
start:
    mov si,0
    mov bx,8
s:  
    mov al,a[si]
    mov ah,0
    add b,ax
    inc si
    loop s
    mov ax,4c00h
    int 21h
code ends
end start