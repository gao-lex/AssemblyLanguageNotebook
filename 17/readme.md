<!-- TOC -->

- [使用BIOS进行键盘输入和磁盘读写](#使用bios进行键盘输入和磁盘读写)
    - [1. int9中断例程对键盘输入的处理](#1-int9中断例程对键盘输入的处理)
    - [2. 使用int 16h中断例程读取键盘缓冲区](#2-使用int-16h中断例程读取键盘缓冲区)
    - [检测点17.1](#检测点171)
    - [3. 字符串的输入](#3-字符串的输入)
    - [4. 应用int13h中断例程对磁盘进行读写](#4-应用int13h中断例程对磁盘进行读写)
    - [实验17](#实验17)
    - [课程设计2](#课程设计2)

<!-- /TOC -->

# 使用BIOS进行键盘输入和磁盘读写

1. 大多数有用的程序都需要处理用户的输入，键盘输入是最基本的输入。
2. 程序和数据通常需要长期存储，磁盘是最常用的存储设备。BIOS为这两种外设的I/O提供了最基本的中断例程。

## 1. int9中断例程对键盘输入的处理

键盘输入将引发9号中断，BIOS提供了`int 9`中断例程。CPU在9号中断发生后，执行`int 9`中断例程，从`60h`端口读出扫描码，并将其转化为相应的ASCII码或状态信息，存储在内存的指定空间(键盘缓冲区或状态字节)中。

一般的键盘输入，在CPU执行完`int 9`中断例程后，都放到了键盘缓冲区中。键盘缓冲区中有16个字单元，可以存储15个按键的扫描码和对应的ASCII码。

## 2. 使用int 16h中断例程读取键盘缓冲区

BIOS提供了`int 16h`中断例程供程序员调用。`int 16h`中断例程中包含的**一个最重要的功能是从键盘缓冲区中读取一个键盘输入**，该功能的编号为`0`。下面的指令从键盘缓冲区中读取一个键盘输入，并且将其从缓冲区中删除。

```asm
mov ah，0
int 16h
;结果: (ah)=扫描码，(al)=ASCII码
```

`int 16h`中断例程检测键盘缓冲区，发现缓冲区空，则循环等待，直到缓冲区中有数据。

`int 16h`中断例程的`0`号功能，进行如下的工作：

1. 检测键盘缓冲区中是否有数据；
2. 没有则继续做第1步；
3. 读取缓冲区第一个字节单元中的键盘输入；
4. 将读取的扫描码送入ah，ASCII码送入al；
5. 将已读取的键盘输入从缓冲区中删除。

```asm
;接收用户的键盘输入
;输入r,将屏幕上的字符设置为红色
;输入g,将屏幕上的字符设置为绿色
;输入b,将屏幕上的字符设置为蓝色
CODES SEGMENT
    ASSUME CS:CODES
START:
	MOV AH,0
	INT 16H 	;读取键盘缓冲区的数据
	
	MOV AH,1	;这边是设置初始颜色为蓝色的吧
	CMP AL,'r'
	JE RED
	CMP AL,'g'
	JE GREEN
	CMP AL,'b'
	JE BLUE
	JMP SHORT SRET
	
RED:
	SHL AH,1	;如果我们输入的是R，那么这边AH左移两位（下面还有SHL AH,1）是00000100
	;这在颜色属性中就是红色
	
GREEN:
	SHL AH,1	;如果是绿色的，只要蓝色属性左移一位便可以
	
BLUE:
	MOV BX,0B800H
	MOV ES,BX
	MOV BX,1
	MOV CX,2000
S:
	AND BYTE PTR ES:[BX],11111000B
	OR ES:[BX],AH
	ADD BX,2
	LOOP S
	JMP SHORT START
	
SRET:
    MOV AH,4CH
    INT 21H
CODES ENDS
END START
```

## 检测点17.1

“在INT 16H中断例程中，一定有设置IF=1的指令。”这说话对吗？

答:对,当键盘缓冲区为空时，如果设置IF=0，int 9中断无法执行，循环等待会死锁。

## 3. 字符串的输入

最简单的字符串输入程序，需要具备下面的功能:

1. 在输入的同时需要显示这个字符串；
2. 一般在输入回车符后，字符串输入结束；
3. 能够删除已经输入的字符。


以栈的方式处理字符串的输入，需要的功能有入栈、出栈、显示。

## 4. 应用int13h中断例程对磁盘进行读写
1. 3.5英寸软盘分为上下两面，每面有80个磁道，每个磁道又分为18个扇区，每个扇区的大小为512个字节。则:`2面*80磁道*18扇区*512字节=1440KB~=1.44MB`
2. 磁盘的实际访问由磁盘控制器进行，我们可以通过控制磁盘控制器来访问磁盘。只能以扇区为单位对磁盘进行读写。在读写扇区的时候，要给出面号、磁道号和扇区号。**面号和磁道号从0开始，而扇区号从1开始。**
3. 如果我们通过直接控制磁盘控制器来访问磁盘，则需要涉及许多硬件细节。BIOS提供了对扇区进行读写的中断例程，这些中断例程完成了许多复杂的和硬件相关的工作。我们可以通过调用BIOS中断例程来访问磁盘。
4. BIOS提供的访问磁盘的中断例程为`int 13h`

## 实验17
安装一个新的int 7ch中断例程,实现通过逻辑扇区号对软盘进行读写.

参数读写:

1. 用ah寄存器传递功能号:0表示读,1表示写
2. 用dx寄存器传递要读写的扇区的逻辑扇区号
3. 用es:dx指向存储读出数据或写入数据的内存区

```asm
assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset int7cstart

    mov ax,0
    mov es,ax
    mov di,200h

    mov cx,offset int7cend - offset int7cstart
    cld
    rep movsb

    mov word ptr es:[4*7ch],200h
    mov word ptr es:[4*7ch+2],0

    mov ax,4c00h
    int 21h

int7cstart:
    cmp ah,1
    ja none

    push ax
    push bx
    push cx
    push dx

    push ax

    mov ax,dx
    mov dx,0
    mov cx,1440
    div cx
    push ax
    mov cx,18
    mov ax,dx
    mov dx,0
    div cx
    push ax
    inc dx
    push dx

    pop ax
    mov cl,al
    pop ax
    mov ch,al
    pop ax
    mov dh,al
    mov dl,0

    pop ax
    mov al,1
    cmp ah, 0
    je read
    cmp ah, 1
    je write

read:
    mov ah,2
    jmp short ok
write:
    mov ah,3
    jmp short ok    
ok: 
    int 13h
    pop dx
    pop cx
    pop bx
    pop ax
none:
    iret    
int7cend:
    nop

code ends
end start
```

## 课程设计2

