
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [call和ret指令](#call和ret指令)
	* [检测点10-1](#检测点10-1)
	* [检测点10-2](#检测点10-2)
	* [检测点10-3](#检测点10-3)
	* [检测点10-4](#检测点10-4)
	* [检测点10-5](#检测点10-5)
		* [10-5-1](#10-5-1)
		* [10-5-2](#10-5-2)

<!-- /code_chunk_output -->


# call和ret指令

|指令|意义|等效代码|
|:---:|:---|:---:|
|`ret`|用栈中的数据修改`ip`的内容<br>近转移|`pop ip`|
|`retf`|用栈中的数据修改`cs`和`ip`的内容<br>远转移|`pop ip`<br>`pop cs`|
|`call`|1.将当前的`ip`或`cs`和`ip`压入栈中<br>2.转移<br>不能实现短转移<br>`call`指令实现转移的原理和`jmp`指令相同|  |
|`call 标号`|将当前的`ip`压栈，转到标号处执行指令|`push ip`<br>`jmp near ptr 标号`|
|`call far ptr 标号`|段间转移<br>之前的`call`对应的机器码中是相对位移|`push cs`<br>`push ip`<br>`jmp far ptr 标号`|
|`call 16位reg`|  |`push ip`<br>`jmp 16位reg`|
|`call word ptr 内存单元地址`|  |`push ip`<br>`jmp word ptr 内存单元地址`|
|`call dword ptr 内存单元地址`|内存单元开始处放着两个字<br>高地址是转移的目的段地址<br>低地址是转移的目的偏移地址|`push cs`<br>`push ip`<br>`jmp dword ptr 内存单元地址`|


## 检测点10-1

```asm
;补全程序，实现从内存1000:0000处开始执行指令
assume cs:code
stack segment
    db 16 dup (0)
stack ends
code segment
start:
    mov ax,stack
    mov ss ,ax
    mov sp,16
    mov ax,1000     ;ans
    push ax
    mov ax,0h       ;ans
    push ax
    retf
code ends
end start
```

## 检测点10-2

下面的程序执行后,`ax`中的数值为多少
|内存地址|机器码|汇编指令|分析|
|:---:|:---|:---|:---|
|1000:0|b8 00 00|`mov ax,0`|
|1000:3|e8 01 00|`call s`|`push 6`<br>`jmp near s`|
|1000:6|40|`inc ax`|
|1000:7|58|`s:pop ax`|`ax=6`|

答案为：6

## 检测点10-3

下面的程序执行后,`ax`中的数值为多少
|内存地址|机器码|汇编指令|分析|
|:---:|:---|:---|:---|
|1000:0|b8 00 00|`mov ax,0`||
|1000:3|9a 09 00 00 10|`call far ptr s`|`push cs(1000)`<br>`push ip(8)`<br>`jmp far s`|
|1000:8|40|`inc ax`|
|1000:9|58|`s:pop ax`<br>`add ax,ax`<br>`pop bx`<br>`add ax,bx`|`ax=8`<br>`ax=10h`<br>`bx=1000h`<br>`ax=1010h`|

答：`ax`中的数值为1010h

## 检测点10-4

下面的程序执行后,`ax`中的数值为多少
|内存地址|机器码|汇编指令|分析|
|:---:|:---|:---|:---|
|1000:0|b8 06 00|`mov ax,6`|
|1000:3|ff d0|`call ax`|`push 5`<br>`jmp ax(6)`|
|1000:5|40|`inc ax`|
|1000:6||`mov bp,sp`<br>`add ax,[bp]`|`bp=sp`<br>`ax+=5`|

答：`ax`中的数值为11

## 检测点10-5
### 10-5-1
下面的程序执行后，`ax`为多少
```asm
assume cs:code
stack segment
    dw 8 dup (0)
stack ends
code segment
start:
    mov ax,stack    ;0000
    mov ss,ax       ;0003
    mov sp,16       ;0005
    mov ds,ax       ;0008
    mov ax,0        ;000a
    call word ptr ds:[0EH]  ;000d;sp=14=0e,ss:[sp]=sp:[000e]=0011,call [000e]
    inc ax          ;0011
    inc ax
    inc ax
    mov ax,4c00h
    int 21h
code ends
end start
```
答：`ax`=3

### 10-5-2

下面程序执行后，`ax`和`bx`中的数值是多少
```asm
assume cs:code
data segment
    dw 8 dup (0)
data segment

code segment
start:
    mov ax,data
    mov ss,ax
    mov sp,16
    mov word ptr ss:[0],offset s    ;ss:[0]=offset s
    mov ss:[2],cs                   ;ss:[2]=cs
    call dword ptr ss:[0]           ;push cs(0e-0f),push ip(0c-0d),jmp dword s
    nop
s:
    mov ax,offset s                 ;ax=offset s
    sub ax,ss:[0ch]                 ;ax=1
    mov bx,cs                       ;bx=cs
    sub bx,ss:[0eh]                 ;bx=0

    mov ax,4c00h
    int 21h

```
答：`ax`为1，`bx`为0
