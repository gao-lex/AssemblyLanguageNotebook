## 实践课项目三

```asm
assume cs:code,ds:data,ss:stack

data segment
    db 'WELCOME TO MASM!'
data ends

stack segment
    dw 0,0,0,0,0,0,0,0
stack ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,10h

    mov bx,0
    mov cx,10h
s:
    mov al,[bx]
    or al,20h
    mov [bx],al
    inc bx
    loop s

    mov ax,4c00h
    int 21h
code ends
end start
```

```bebug
r->ds=075a
d ds:0->
```

## 3-4
![](./image/hw-3-4.png)