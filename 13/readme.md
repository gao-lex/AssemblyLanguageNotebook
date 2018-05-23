
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [int指令](#int指令)
	* [1 int 指令](#1-int-指令)
	* [检测点13.1](#检测点131)
	* [2 bios和dos所提供的中断例程](#2-bios和dos所提供的中断例程)
	* [3 bios和dos中断例程的安装过程](#3-bios和dos中断例程的安装过程)
	* [检测点13.2](#检测点132)
	* [4 BIOS中断例程的应用](#4-bios中断例程的应用)
	* [5 DOS中断例程的应用](#5-dos中断例程的应用)

<!-- /code_chunk_output -->



# int指令


## 1 int 指令
格式：`int n`,`n`为中断类型码

执行过程：

1. 取中断类型码
2. 标志寄存器入栈，`if=0`，`tf=0`
3. `cs`、`ip`入栈
4. `(ip)=(n*4)`，`(cs)(n*4+2)`

int指令和call指令相似，都是调用一段程序。

```asm
;在屏幕中间显示一个!,然后显示"divide overflow"后返回系统中
assume cs:code

code segment
start:
    mov ax,0b800h
    mov es,ax
    mov byte ptr es:[12*160+40*2],'!'
    int 0
code ends
end start
```

## 检测点13.1

1. 用中断例程实现`loop`所能进行的最大转移位移是多少？

答：64KB

2. 用中断例程完成`jmp near ptr s`指令的功能，用`bx`向中断例程传送转移位移。

应用举例：在屏幕的第12行，显示`data`段中以`0`结尾的字符串。

```asm
;应用程序
assume cs:code
data segment
    db 'conversation',0
data ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov si,0
    mov ax,0b800h
    mov es,ax
    mov di,12*160
s:
    cmp byte ptr [si],0
    je ok
    mov al.[si]
    mov es:[di],al
    inc si
    add di,2
    mov bx,offset s-offset ok;转移位移
    int 7ch;跳转到s处
ok:
    mov ax,4c00h
    int 21h
code ends
end start
```

```asm
;安装程序
assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset jpn;设置ds:si指向源地址
    mov ax,0
    mov es,ax
    mov di,200h;设置es:di指向目的地址
    mov cx,offset jpnend-offset jpn
    cld
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h
jpn:
    push bp
    mov bp,sp
    add [bp+2],bx
    pop bp
    iret
jpnend:
    nop
code ends
end start
```

## 2 bios和dos所提供的中断例程

bios中主要包含以下内容：

1. 硬件系统的检测和初始化程序
2. 外部中断和内部中断的中断例程
3. 用于对硬件设备进行i/o操作的中断例程
4. 其他和硬件系统相关的中断例程

dos也提供了中断例程，从操作系统的角度来看，dos中断例程就是操作系统向程序员提供的编程资源。

和硬件设备相关的dos中断例程一般都调用了bios的中断例程

## 3 bios和dos中断例程的安装过程

1. 开机，cpu加电，(cs)=0ffffh,(ip)=0,从ffff:0单元开始执行。FFFF:0处有一条跳转指令，cpu执行后，转去执行bios中的硬件系统检测和初始化程序。
2. 初始化程序将建立BIOS所支持的中断向量（将BIOS提供的中断例程的入口地址登记在中断向量表中）。
3. 硬件系统检测和初始化完成后，调用`int 19h`进行操作系统的引导。从此将计算机交由操作系统检测。
4. dos启动后，除其他工作外，将dos所提供的中断例程装入内存，并建立相应的中断向量。

## 检测点13.2

1. 我们可以改变FFFF:0处的指令，使cpu不去执行bios中的硬件系统检测和初始化程序。

答：错误,因为bios是不可写的,不能向里面写程序

2. `int 19h`中断例程，可以由dos提供

答：错误，19号中断是引导操作系统的,必须在在操作系统还没有执行前提供

## 4 BIOS中断例程的应用

`int 10h`由BIOS提供，包含多个和屏幕输出相关的子程序。

一般来说，一个供程序员调用的中断例程往往包括多个子程序，中断例程内部用传递进来的参数决定执行哪一个子程序。BIOS和DOS提供的中断例程，由`ah`来传递内部子程序的编号。

```asm
mov ah,2    ;2号子程序，功能:置光标
mov bh,0    ;第0页
mov dh,5    ;dh中放行号
mov dl,12   ;dl中放列号
int 10h
```

显示缓冲区B8000H~BFFFFH共32KB的空间,分8页，每页4KB，80*25。默认显示第0页的内容。

```asm
mov ah,9    ;在光标位置显示字符
mov al,'a'  ;字符
mov bl,7    ;颜色属性
mov bh,0    ;第0页
mov cx,3    ;字符重复个数
int 10h
```

## 5 DOS中断例程的应用

`int 21h`是DOS提供的中断例程。

```asm
;int 21h中断例程的4ch号功能：程序返回功能
mov ah,4ch
mov al,0
int 21h
```

```asm
;在光标位置显示字符串
ds:dx 指向字符串    ;以"$"作为结束符
mov ah,9            ;功能号9，在光标位置显示字符串
int 21h
```

