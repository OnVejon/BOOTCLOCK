assume cs:code
code segment
start:
	jmp far ptr start1
	msg1 db '1)set mounth(1~12):',0 ;显示信息 
	msg2 db '2)set day   (1~30):',0 ;显示信息 
	msg3 db '3)set hour  (0~23):',0 ;显示信息 
	msg4 db '4)set minute(0~59):',0 ;显示信息 
	msg5 db '5)show clock',0 ;	
	msg6 db 'error input',0 ;	
	clock dw 0,820h	
start1:
	call cls
	;显示提示
	push cs
	pop ds
	mov dx,0304h
	mov si,offset msg1 
	call display 		
	mov dx,0504h	
	mov si,offset msg2 			
	call display 
	mov dx,0704h
	mov si,offset msg3 			
	call display 
	mov dx,0904h
	mov si,offset msg4 			
	call display 
	mov dx,0b04h
	mov si,offset msg5			
	call display 
	;
start0:	
	mov ah,0
	int 16h
	
	mov dh,02h
	mov dl,25
	cmp ah,02h
	je	set_mounth
	cmp ah,03h
	je 	set_day
	cmp ah,04h
	je	set_hour
	cmp ah,05h
	je	set_minute
	cmp ah,06h
	je	show_clock

	jmp short start0
	mov ax,4c00h
	int 21h


set_minute:
	add dh,2
set_hour:
	add dh,2
set_day:
	add dh,2
set_mounth:
	mov ah,2 
	int 10h
sss:
	call getstr
	
	
	call writetime
	jmp short start0
show_clock:
	jmp dword ptr clock


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;dh,dl;
;ds:[si]
display:
        push ax
        push dx 
       
        push di 
		push es
        mov ax,0b800h 
        mov es,ax 
 	
        mov ax,0a0h
		dec dh 
        mul dh 
        mov di,ax 
        mov ax,2 
        mul dl 
       
		add di,ax
       
       	
show_display:
	
		cmp byte ptr ds:[si],0       
        je show_ok
        mov al,byte ptr ds:[si] 
        mov byte ptr es:[di],al
        add di,2 
        inc si         
        jmp short show_display           
show_ok:
		pop es
        pop di 
       
        pop dx 
        pop ax
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;
;
cls:
	push bx
	push cx
	push es
	mov bx,0b800h
	mov es,bx
	mov bx,0 
	mov cx,2000
cls_s:
	mov byte ptr es:[bx],' '
	add bx,2
	loop cls_s
	pop es
	pop cx
	pop bx
	ret
	
savedl db 0
getstr:	
	push ax
	push bx
	push cx
	push dx
	mov savedl,dl
	inc byte ptr savedl
getstrs:
	cmp byte ptr savedl,dl
	jb jh
jhok:
	mov ah,2 
	int 10h
	mov ah,0
	int 16h
	cmp al,30h
	jb nochar
	cmp al,39h
	ja nochar
	mov ah,9
	mov	bh,0
	mov bl,7
	mov cx,1
	int 10h 
	inc dl
	jmp getstrs
nochar:
	cmp ah,0eh
	je backspace
	cmp ah,1ch
	je enter0
	jmp getstrs
backspace:
	
	cmp dl,savedl 
	jb getstrs
	mov ah,9
	mov al,0
	mov	bh,0
	mov bl,1
	mov cx,1
	int 10h 
	dec dl
	jmp getstrs
	
enter0:
	mov ah,2 
	add dh,1
	sub dl,20
	int 10h
	pop dx
	pop cx
	pop bx
	pop ax
	ret
jh:
	mov dl,savedl
	dec dl 
	jmp jhok
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;al,dh,dl

writetime:
	push ax
	push bx 
	push cx
	push es 
	push di
	
	cmp dh,2
	je chmouth
	cmp dh,4
	je chday
	cmp dh,6
	je chhour
	cmp dh,8
	je chminute
	jmp wret
change:	
	mov cl,al
	mov bx,0b800h
	mov es,bx
	mov al,160
	mov ah,0
	mul dh
	mov di,ax
	add dl,dl
	mov dh,0 
	add di,dx 
	
	mov al,cl
	out 70h,al
	
	mov ah,byte ptr es:[di]
	mov al,byte ptr es:[di+2]
	sub ah,30h
	sub al,30h
	mov cl,4
	shl ah,cl
	or al,ah
	out 71h,al
wret:
	pop di 
	pop es
	pop cx
	pop bx
	pop ax
	ret
chmouth:
	mov al,8
	jmp short change
chday:
	mov al,7
	jmp short change
chhour:
	mov al,4
	jmp short change
chminute:
	mov al,2
	jmp short change

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

code ends
end start	