assume cs:codesg
codesg segment
    mov ax,4c00h        ;a
    int 21h
start:
    mov ax,0
s:
    nop                 ;nop的机器码占一个字节
                        ;a-b之间的长度和s1到s2jmp结束的长度是一样的
    nop                 ;b
    mov di,offset s
    mov si,offset s2
    mov ax,cs:[si]
    mov cs:[di],ax      ;把s2处的jmp short s1代码复制到s处，而该jmp代码实质是偏移-(x+2)个字节单位。
s0:
    jmp short s
s1:
    mov ax,0
    int 21h
    mov ax,0            ;;设s1开始的这三句占据x字节
s2:
    jmp short s1        ;这句jmp本身占据2字节，则此处实质偏移量为-(x+2)
                        ;标号处的地址-`jmp`指令后的第一个字节的位置
    nop
codesg ends
end start