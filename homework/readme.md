## 实践课项目三

### 3-1
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

### 3-2

```
assume cs:code,ds:data

data segment
    db 184,0,76,205,33
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,od
    mov es,ax
    mov bx,0
    mov cx,6
s:
    mov al,[bx]
    mov es:[bx],al
    inc bx
    loop s

od segment
    db 0,0,0,0,0
od ends

end start
```

### 3-3

```
assume cs:code,ds:data,ss:stack


code segment
start:
    and ax,01h
    mov cx,ax
    jcxz s1
    mov bx,1
s1:
    mov bx,0

    mov ax,4c00h
    int 21h
code ends
end start
```


### 3-4
![](./image/hw-3-4.png)