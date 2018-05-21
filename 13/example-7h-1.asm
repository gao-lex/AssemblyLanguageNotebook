assume cs:code

code segment
start:
    ;安装程序，将其安装在0:200处
    mov ax,cs
    mov ds,ax
    mov si,offset sqr;设置ds:si指向源地址
    mov ax,0
    mov es,ax
    mov di,200h     ;设置es:di指向目的地址
    mov cx,offset sqrend-offset sqr;cx为传输长度
    cld             ；传输方向为正
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h

sqr:
    mul ax
    iret    
    ;int指令和call指令的配合使用与call和ret的配合使用具有相似的思路
sqrend:
    nop

    mov ax,3456     ;(ax)=3456
    int 7ch         ;调用中断7ch的中断例程，计算ax中的数据的平方
    add ax,ax       
    adc dx,dx       ;dx:ax存放结果，将结果乘以2
    mov ax,4c00h
    int 21h

code ends
end start