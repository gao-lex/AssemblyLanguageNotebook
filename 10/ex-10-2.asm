assume cs:code

code segment
start:
    mov ax,4240h    ;低16位
    mov dx,000fh    ;高16位
    mov cx,0ah      ;除数
    call divdw
divdw:
    mov bx,ax       ;bx=ax
    mov bp,dx       ;bp=dx

    mov ax,dx       ;16位除法低位
    mov dx,0        ;16位除法高位
    div cx          ;ax/cx;商ax,余数dx
                    ;乘以65536相当于变成高16位
    

code ends
end start