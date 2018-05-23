;code,a,b,start,s都是标号
;这些标号仅仅表示了内存单元的地址
;我们称这种标号为地址标号
assume cs:code
code segment
    a: db 1,2,3,4,5,6,7,8
    b: dw 0
start:
    mov si,offset a
    mov bx,offset b
    mov cx,8
s:  
    mov al,cs:[si]
    mov ah,0
    add cs:[bx],ax
    inc si
    loop s
    mov ax,4c00h
    int 21h
code ends
end start