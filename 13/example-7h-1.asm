assume cs:code

code segment
start:
    ;安装程序，将其安装在0:200处
    mov ax,cs
    mov ds,ax
    mov si,offset sqr;设置ds:si指向源地址
    mov ax,3456     ;(ax)=3456
    int 7ch         ;调用中断7ch的中断例程，计算ax中的数据的平方
    add ax,ax       
    adc dx,dx       ;dx:ax存放结果，将结果乘以2
    mov ax,4c00h
    int 21h

code ends
end start