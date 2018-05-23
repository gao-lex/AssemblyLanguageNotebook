<!-- TOC -->

- [直接定址表](#直接定址表)
    - [1 描述了单元长度的标号](#1-描述了单元长度的标号)
    - [检测点 16.1](#检测点-161)
    - [2 在其他段中使用数据标号](#2-在其他段中使用数据标号)

<!-- /TOC -->

# 直接定址表

## 1 描述了单元长度的标号

|地址标号|数据标号|
|:---:|:---:|
|![](./image/example1.png)|![](./image/example2.png)|

## 检测点 16.1

补全程序:

```asm
assume cs:code
code segment
    a dw 1,2,3,4,5,6,7,8
    b dd 0
start: 
    mov si, 0
    mov cx, 8
s:  
    mov ax, a[si]
    add word ptr b[0], ax
    adc word ptr b[2], 0
    add si, 2
    loop s
    mov ax, 4c00H
    int 21H
code ends
end start
```

## 2 在其他段中使用数据标号

