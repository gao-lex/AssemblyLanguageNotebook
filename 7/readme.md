
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [更灵活的定位内存地址的方法](#更灵活的定位内存地址的方法)
	* [1-and和or指令](#1-and和or指令)
	* [3-以字符形式给出的数据](#3-以字符形式给出的数据)
	* [4-大小写转换的问题](#4-大小写转换的问题)
	* [5-[bx+idata]](#5-bxidata)
	* [6-用[bx+idata]的方式进行数组的处理](#6-用bxidata的方式进行数组的处理)
	* [7-SI和DI](#7-si和di)
	* [8-[bx+si]和[bx+di]](#8-bxsi和bxdi)
	* [9-[bx+si+idata]和[bx+di+idata]](#9-bxsiidata和bxdiidata)

<!-- /code_chunk_output -->

# 更灵活的定位内存地址的方法

## 1-and和or指令

and|or
---|---
逻辑与指令，按位进行与运算|逻辑或指令，按位进行或运算

## 3-以字符形式给出的数据

在汇编中用`'......'`指明数据是以字符形式给出的，编译器讲把它们转化成对应的ASCII码。

```asm
assume cs:code,ds:data
data segment
    db 'unIX'
    db 'foRk'
data ends
code segment
start: 
    mov al,'a'
    mov bl,'b'
    mov ax,4c00h
    int 21h
code ends
end start
```

## 4-大小写转换的问题

```asm
assume cs:code,ds:datasg
datasg segment
    db 'Basic'
    db 'iNfOrMaTion'
datasg ends
codesg segment
start:
    mov ax,datasg   
    mov ds,ax       ;设置ds指向datasg

    mov bx,0        ;设置(bx)指向0，ds:bx指向‘Basic’的第一个字母
    mov cx,5        ;循环次数5
s:  mov al,[bx]     ;将ASCII码从ds:bx所指向的单元中取出
    and al,11011111B    ;将al中的ASCII码的第5位置为0，变为大写字母
    mov [bx],al     ;将转变后的ASCII码写回原单元
    inc bx          ;(bx)+1，ds:bx指向下一个字母
    loop s
    
    mov bx,5
    mov cx,11
s0: mov al,[bx]
    or al,00100000B
    mov [bx],al
    inc bx
    loop s0

    mov ax,4c00h
    int 21h
codesg ends
end start
```

## 5-[bx+idata]

`[bx+idata]`表示一个内存单元，它的偏移地址为(bx)+idata

**书中本节最后一行有错误**

## 6-用[bx+idata]的方式进行数组的处理

```asm
assume cs:codesg,ds:datasg
datasg segment
    db 'Basic'
    db 'iNfOrMaTion'
datasg ends
codesg segment
start:
    mov ax,datasg   
    mov ds,ax       ;设置ds指向datasg
    mov bx,0        ;设置(bx)指向0，ds:bx指向‘Basic’的第一个字母
    mov cx,5        ;循环次数5
s:  mov al,[bx]     ;等于mov al,0[bx]
    and al,11011111b
    mov [bx],al
    mov al,[5+bx]
    or al,00100000b
    
    mov [5+bx],al   ;等于mov al,5[bx]
    inc bx
    loop s

codesg ends
end start
```
## 7-SI和DI

`si`和`di`是8086CPU中和`bx`功能相近的寄存器，不能分成两个８位寄存器来使用

```asm
assume cs:codesg,ds:datasg
datasg segment
    db 'welcome to masm!'
    db '................'
datasg ends
codesg segment
start:
    mov ax,datasg   ;mov ax,datasg
    mov ds,ax       ;mov ds,ax
    mov si,0        ;mov si,0
    mov di,16       
    mov cx,8        ;mov cx,8
s:  mov ax,[si]     ;mov ax,0[si]
    mov [di],ax     ;mov 16[si],ax
    add si,2        ;add si,2
    add di,2        ;loop s
    loop s

    mov ax,4c00h
    int 21h
codesg ends
end start
```

## 8-[bx+si]和[bx+di]

`[bx+si]`表示一个内存单元，它的偏移地址为`(bx)+(si)`
`mov ax,[bx+si]`==`mov ax,[bx][si]`

## 9-[bx+si+idata]和[bx+di+idata]

`[bx+si+idata]`表示一个内存单元，它的偏移地址为`(bx)+(si)+idata`

## 