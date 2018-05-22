assume cs:code

code segment
start:
    mov al,8
    out 70h,al
    in al,71h   ;获得当前月份的BCD码

    mov ah,al
    mov cl,4
    shr ah,cl   ;ah为月份的十位数BCD码
    and al,00001111b;al为月份的个位数BCD码
    
    add ah,30h
    add al,30h

    mov bx,0b800h
    mov es,bx
    mov byte ptr es:[160*12+40*2],ah
    mov byte ptr es:[160*12+40*2+2],al

    mov ax,4c00h
    int 21h

code ends
end start