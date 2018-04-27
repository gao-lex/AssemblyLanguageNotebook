assume cs:code,ds:data,es:table

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上是表示21年的字符串 4 * 21 = 84

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示21年公司总收入的dword型数据 4 * 21 = 84

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;以上是表示21年公司雇员人数的21个word型数据 2 * 21 = 42
data ends

table segment
    db 21 dup ('year summ ne ?? ') ; 'year summ ne ?? ' 刚好16个字节
table ends

code segment
start:
    ;data数据 放在ds
    mov ax,data
    mov ds,ax
    ;table数据 放在 es
    mov ax,table
    mov es,ax
    ;三个寄存器初始化
    mov bx,0 ;data中数据定位（和idata结合，用于年份和收入）
    mov si,0 ;table中定位（和idata给合用于定位存放数据的相对位置）
    mov di,0 ;data中用于得到员工数
    ;cx循环次数
    mov cx,21
    ;循环内容
s:
    ;将年从data 到 table 分为高16位和低16位
    mov ax,[bx]
    mov es:[si],ax
    mov ax,[bx+2]
    mov es:[si+2],ax

    ;空格
    ;table 增加空格
    mov byte ptr es:[si+4],20h

    ;收入
    ;将收入从data 到 table 分为高16位和低16位
    mov ax,[bx+84]
    mov es:[si+5],ax
    mov ax,[bx+86]
    mov es:[si+7],ax

    ;空格
    ;table 增加空格
    mov byte ptr es:[si+ 9],20h

    ;雇员数
    ;将雇员数从data 到 table 
    mov ax,[di + 168]
    mov es:[si + 10],ax

    ;空格
    ;table 增加空格
    mov byte ptr es:[si+12],20h

    ;计算工资
    ;取ds处工资,32位
    mov ax,[bx + 84]
    mov dx,[bx + 86]
    ;计算人均收入
    div word ptr ds:[di + 168]
    ;将结果存入table处
    mov es:[si+13],ax

    ;空格
    ;table 增加空格
    mov byte ptr es:[si + 0fh],20h

    ;改变三个寄存器值
    add si,16
    add di,2
    add bx,4

    loop s

    mov ax,4ch
    int 21h
code ends
end start