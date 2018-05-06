;名称：`show_str`
;功能：在指定的位置，用指定的颜色，显示一个以0结束的字符串
;参数：`dh`=行号(0~24),`dl`=列号(0~79),`cl`=颜色,`ds:si`指向字符串的首地址
;返回：无
;应用举例：在屏幕的8行3列，用绿色显示`data`段中的字符串

assume cs:code
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:
    mov dh,8    ;8行
    mov dl,3    ;3列
    mov cl,2    ;绿色
    mov ax,data
    mov ds,ax
    mov si,0
    call show_str

    mov ax,4c00h
    int 21h
show_str:
    mov ax,0b800h   ;0开头表示是数值而不是符号
    mov es,ax   ;es=b800h

    mov al,160
    sub dh,1
    mul dh      ;ax=160*(dh-1)
    mov bx,ax   ;bx=ax

    sub dl,1
    mov al,2
    mul dl      ;ax=2*(dl-1)

    add bx,ax   ;bx=bx+ax

    mov dh,cl   ;字符颜色
    mov di,0
    mov ch,0
s:
    mov cl,ds:[si]
    jcxz zero
    mov dl,ds:[si]
    mov es:[bx+di],dx
    add di,2
    add si,1
    loop s
zero:
    ret


code ends
end start