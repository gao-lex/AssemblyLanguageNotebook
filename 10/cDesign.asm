assume cs:code
data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;表示21年的21个字符串
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;表示21年公司总收入的dword型数据
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;表示21年公司雇员人数的21个word型数据
data ends
stack segment
    db 20 dup (0)
stack ends
string segment
    db 21 dup ('1970      0         0         0        ',0);这里是40个字节一行
string ends
code segment
start:  
    mov ax,stack
    mov ss,ax
    mov sp,32;指针指向栈空间
    mov ax,data
    mov ds,ax
    mov bx,0
    mov di,0
    mov ax,string
    mov es,ax
    mov si,0;指向数据空间
    mov cx,21
    s0:  
        push cx
        mov ax,[bx+0]
        mov es:[si],ax
        add si,2
        mov ax,[bx+2]
        mov es:[si],ax;写入年份
        add si,2
        add si,6;6字节不写
        mov ax,[bx+54H]
        mov dx,[bx+54H+2]
        call dtocdw;总收入10进制转换成字符串并写入
        add si,10
        mov ax,[di+0A8H]
        call dtoc;雇员人数10进制转换成字符串并写入
        add si,10
        mov ax,[bx+54H+0]
        mov dx,[bx+54H+2]
        mov cx,[di+0A8H];这里改变了cx，记得用后还原
        call divdw;得到人均收入，(dx)=高16位，(ax)=低16位
        call dtocdw;人均收入10进制转换成字符串并写入
        add si,10;有一个0作为结束标记，占1字节，其余9个空格，初始化时定义
        add bx,4
        add di,2
        pop cx
        loop s0
    mov dh,4;更完善的可以之前做一下清屏工作   
    mov ax,string
    mov ds,ax
    mov bx,0
    mov cx,21
    s1:
        push cx;这里改变了cx，记得用后还原
        mov dl,3
        mov cl,00000010B
        call show_str;调用show_str子程序,显示一行数据
        inc dh
        inc bx
        pop cx
        loop s1
    ;mov ah,0
    ;int 16H;按任意键继续，可直接双击运行
    mov ax,4C00H
    int 21H
;名称：dtoc
;功能：将十进制数据转化为字符串
;参数：(ax)是十进制数据，ss:[sp]指向stack栈底，es:[si]指向string当前
;返回：在string标号内存空间的字符串，si不变
dtoc:   
    push ax
    push bx
    push cx
    push dx
    push es
    mov bx,0
    numToChar:  
        mov dx,0
        mov cx,10
        div cx
        add dx,30H
        push dx
        inc bx;(bx)代表栈中有几个字符
        mov cx,ax;商为0代表数字处理结束
        jcxz stackToString
        jmp short numToChar
    stackToString:  
        mov cx,bx
    mov bx,0
    dtocS1: 
        pop ax
        mov es:[bx+si],al;一次取一个字
        inc bx
        loop dtocS1
    dtocOk: 
        pop es
        pop dx
        pop cx
        pop bx
        pop ax;注意按原本顺序倒序出栈
        ret
;名称：dtocdw
;功能：将dword型十进制数据转化为字符串
;参数：(ax)是dword型十进制数据低16位，(dx)是dword型十进制数据高16位，es:[si]指向string当前
;返回：在string标号内存空间的字符串，si不变
dtocdw: 
    push ax
    push bx
    push cx
    push dx
    push es
    mov bx,0
    numToCharDw:  
        mov cx,10
        call divdw;被除数在dx和ax中，余数在cx中
        add cx,30H
        push cx
        inc bx;(bx)代表栈中有几个字符
        mov cx,dx
        or cx,ax;商为0代表数字处理结束
        jcxz stackToStringDw
        jmp short numToCharDw
    stackToStringDw:  
        mov cx,bx
    mov bx,0
    dtocdwS1: 
        pop ax
        mov es:[bx+si],al;一次取一个字
        inc bx
        loop dtocdwS1
    dtocdwOk: 
        pop es
        pop dx
        pop cx
        pop bx
        pop ax;注意按原本顺序倒序出栈
        ret
;名称：divdw
;功能：除法，被除数32位，除数16位，商32位，余数16位，不会溢出
;参数：(dx)=被除数的高16位，(ax)=被除数的低16位，(cx)=除数
;返回：(dx)=商的高16位，(ax)=商的低16位，(cx)=余数
divdw:  
    push bx
    push ax
    mov ax,dx;(ax)=000FH
    mov dx,0;(dx)=0
    div cx;000FH÷0AH=0001H......5H,(ax)=0001H,(dx)=5H
    mov bx,ax;(bx)=0001H
    pop ax;(ax)=4240H
    div cx;54240H÷0AH=86A0H......0H,(ax)=86A0H,(dx)=0H,(rem(H/N)*65536+L)/N的商
    mov cx,dx;(cx)=0H;(rem(H/N)*65536+L)/N的余数
    mov dx,bx;(dx)=0001H,int(H/N)
    pop bx;(bx)=0H
    ret
;名称：show_str
;功能：在屏幕指定位置，用指定颜色，显示一个用0结尾的字符串
;参数：参数：(dh)=行号，(dl)=列号（0～80），(cl)=颜色，ds:[bx]：该字符串的首地址
;返回：显示在屏幕上
show_str:   
    push cx
    push ax
    push dx
    push es
    push si;保存现场
    mov ax,0B800H
    mov es,ax
    mov al,160
    mul dh
    sub ax,160
    add dl,dl;最多80+80=160=0A0H，没有进位问题
    mov dh,0
    add ax,dx;得到第dh行第dl列的的显示器偏移地址,一列偏移2字节
    mov si,ax;这时es:[si]指向了指定的显示器地址
    mov ah,cl;ah存放颜色格式，循环中不再改变
    change: 
        mov cl,[bx]
        mov ch,0
        jcxz show_strOk;到0转到标号ok执行
        mov al,[bx];得到数据放入al
        mov es:[si],ax
        add si,2;下一个字母到下一列
        inc bx
        jmp short change;注意再跳到change标号，否则直接到ok标号处执行
    show_strOk: 
        pop si
        pop es
        pop dx
        pop ax
        pop cx
        ret
code ends
end start
