```asm
;csc.asm==changeScreenColor.asm
assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,128

    push cs
    pop ds

    mov ax,0
    mov es,ax

    mov si,offset int9
    mov di,204h
    mov cs,offset int9end-offset int9
    cld
    rep movsb

    push es:[9*4]
    pop es:[200h]
    push es:[9*4+2]
    pop es:[202h]

    cli
    mov word ptr es:[9*4],204h
    mov word ptr es:[9*4+2],0
    sti

    mov ax,4c00h
    int 21h

int9:
    push ax
    push bx
    push cx
    push dx

    in al,60h

    pushf
    call dword ptr cs:[200h];当此中断时执行0:200

    cmp al,3bh;F1的扫描码是3bh
    jne int9ret

    mov ax,0b800h
    mov es,ax
    mov bx,1
    mov cx,2000
s:
    int byte ptr es:[bx]
    add bx,2
    loop s
int9ret:
    pop es
    pop cx
    pop bx
    pop ax
    iret
int9end:
    nop
code ends
end start
    
```