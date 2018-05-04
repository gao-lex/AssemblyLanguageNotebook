
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [call和ret指令](#call和ret指令)
	* [检测点10-1](#检测点10-1)
	* [检测点10-2](#检测点10-2)
	* [检测点10-3](#检测点10-3)
	* [检测点10-4](#检测点10-4)

<!-- /code_chunk_output -->


# call和ret指令

|指令|意义|等效操作|等效代码|
|:---:|:---|:---:|:---|
|`ret`|用栈中的数据修改`ip`的内容<br>近转移|`(ip)=((ss)*16+(sp))`<br>`(sp)=(sp)+2`|`pop ip|
|`retf`|用栈中的数据修改`cs`和`ip`的内容<br>远转移|`(ip)=((ss)*16+(sp))`<br>`(sp)=(sp)+2`<br>`(cs)=((ss)*16+(sp))`<br>`(sp)=(sp)+2`|`pop ip`<br>`pop cs`|
|`call`|1.将当前的`ip`或`cs`和`ip`压入栈中<br>2.转移<br>不能实现短转移<br>`call`指令实现转移的原理和`jmp`指令相同||
|`call 标号`|将当前的`ip`压栈，转到标号处执行指令|`(sp)=(sp)-2`<br>`((ss)*16+sp)=(ip)`<br>`(ip)=(ip)+16位位移`|`push ip`<br>`jmp near ptr 标号`|
|`call far ptr 标号`|段间转移<br>之前的`call`对应的机器码中是相对位移|`(sp)=(sp)-2`<br>`((ss)*16+(sp))=cs`<br>`(sp)=(sp)-2`<br>`((ss)*16+(sp))=(ip)`|`push cs`<br>`push ip`<br>`jmp far ptr 标号`|
|`call 16位reg`||`(sp)=(sp)-2`<br>`((ss)*16+(sp))=(ip)`<br>`(ip)=(16位reg)`|`push ip`<br>`jmp 16位reg`|
|`call word ptr 内存单元地址`|||`push ip`<br>`jmp word ptr 内存单元地址`|
|call||||


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
|内存地址|机器码|汇编指令|
|:---:|:---|:---|
|1000:0|b8 00 00|`mov ax,0`|
|1000:3|e8 01 00|`call s`|
|1000:6|40|`inc ax`|
|1000:7|58|`s:pop ax`|

答案为：3

## 检测点10-3

下面的程序执行后,`ax`中的数值为多少
|内存地址|机器码|汇编指令|
|:---:|:---|:---|
|1000:0|b8 00 00|`mov ax,0`|
|1000:3|9a 09 00 00 10|`call far ptr s`|
|1000:8|40|`inc ax`|
|1000:9|58|`s:pop ax`<br>`add ax,ax`<br>`pop bx`<br>`add ax,bx`|

答：`ax`中的数值为1006

## 检测点10-4

下面的程序执行后,`ax`中的数值为多少
|内存地址|机器码|汇编指令|
|:---:|:---|:---|
|1000:0|b8 06 00|`mov ax,6`|
|1000:3|ff d0|`call ax`|
|1000:5|40|`inc ax`|
|1000:6||`mov bp,sp`<br>`add ax,[bp]`|

答：`ax`中的数值为9

## 