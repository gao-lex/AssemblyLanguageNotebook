mov ax,seg
mov ds,ax
mov bx,60h
mov word ptr [bx].0ch,38
add word ptr [bx].0eh,70

mov si,0
mov byte ptr [bx].10h[si],'V'
inc si
mov byte ptr [bx].10h[si],'A'
inc si
mov byte ptr [bx].10h[si],'X'