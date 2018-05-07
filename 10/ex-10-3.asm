assume cs:code

data segment
    db 10 dup  (0)
data ends
code segment
start:
    mov ax,12666
    mov bx,data
    mov ds,bx
    mov si,0
    call dtoc

    mov dh,8
    mov dl,3
    mov cl,2
    call show_str

    mov ax,4c00h
    int 21h
dtoc:
    mov dx,0
    mov bx,10
    div bx      ;`AX`存商，`DX`存余数
    mov cx,ax
    add dl,30h
    mov ds:[si],dl
    inc si
    jcxz zerodiv    ;商为0
    inc cx
    loop dtoc

zerodiv:
    mov ax,0
    mov ds:[si],ax

    mov ax,si
    mov di,si
    mov bx,2
    mov dx,0
    div bx     ;ax存商，dx存余数
    mov si,0
    mov bx,ax   ;ax=字符串长度的1/2
    sub di,1
    mov cx,ax
swapos:
    mov dh,ds:[di]
    mov dl,ds:[si]
    mov ds:[di],dl
    mov ds:[si],dh
    inc si
    sub di,1
    loop swapos
    ret

show_str:
    mov si,0
    mov ax,0b800h   ;0开头表示是数值而不是符号
    mov es,ax   ;es=b800h

    mov al,160
    sub dh,1
    mul dh      ;ax=160*(dh-1)
    mov bx,ax   ;bx=ax

    sub dl,1
    mov al,2
    mul dl      ;ax=2*(dl-1)

    add bx,ax   ;bx=bx+ax

    mov dh,cl   ;字符颜色
    mov di,0
    mov ch,0
s:
    mov cl,ds:[si]
    jcxz zero
    mov dl,ds:[si]
    mov es:[bx+di],dx
    add di,2
    add si,1
    loop s
zero:
    ret
code ends
end start