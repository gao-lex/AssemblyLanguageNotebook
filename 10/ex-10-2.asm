assume cs:code

code segment
start:
    mov ax,4240h    ;低16位
    mov dx,000fh    ;高16位
    mov cx,0ah      ;除数
    call divdw
    
    mov ax,4c00h
    int 21h
divdw:
    mov bx,ax       ;bx=ax

    mov ax,dx       ;ax=dx
    mov dx,0        ;dx=0
    div cx          ;dx ax/cx;商ax,余数dx
                    ;乘以65536相当于变成高16位
    mov di,ax
    mov ax,bx
    div cx

    mov cx,dx
    mov dx,di

    ret

code ends
end start