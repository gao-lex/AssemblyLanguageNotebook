
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [call和ret指令](#call和ret指令)
	* [ret和retf](#ret和retf)
	* [监测点10-1](#监测点10-1)

<!-- /code_chunk_output -->


# call和ret指令

|指令|意义|等效操作|等效代码|
|:---:|:---|:---:|:---|
|`ret`|用栈中的数据修改`ip`的内容<br>近转移|`(ip)=((ss)*16+(sp))`<br>`(sp)=(sp)+2`|`pop ip|
|`retf`|用栈中的数据修改`cs`和`ip`的内容<br>远转移|`(ip)=((ss)*16+(sp))`<br>`(sp)=(sp)+2`<br>`(cs)=((ss)*16+(sp))`<br>`(sp)=(sp)+2`|`pop ip`<br>`pop cs`|
|`call`|1.将当前的`ip`或`cs`和`ip`压入栈中<br>2.转移<br>不能实现短转移<br>`call`指令实现转移的方法和`jmp`指令的原理相同||
|`call 标号`|将当前的`ip`压栈，转到标号处执行指令|`(sp)=(sp)-2`<br>`((ss)*16+sp)=(ip)`<br>`(ip)=(ip)+16位位移`|`push ip`<br>`jmp near ptr 标号`|

## ret和retf

ret指令用栈中的数据修改ip的内容，从而实现近转移
retf指令用栈中的数据修改cs和ip的内容，从而实现远转移

## 监测点10-1
```
assume cs:code
stack segment
    db 16 dup (0)
stack ends
code segment
start:
    mov ax,stack
    mov ss ,ax
    mov sp,16
    mov ax,0        ;ans
    push ax
    mov ax,1000h    ;ans
    push ax
    retf
code ends
end start
```

## 