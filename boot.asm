
assume cs:code 
code segment 
;7e00h:reboot; 8000h:clock; 	8200h:setclock	8400h: sys
;
start:
	sti
	mov ax,07c0h
	mov ds,ax		;ds 是显示字符的短地址
	
	
	

	;时钟程序导入内存
	
	
	mov ax,0
	mov es,ax
	mov bx,7e00h
	mov al,4
	mov ch,0
	mov cl,2 
	mov dh,0 
	mov dl,0
	mov	ah,2 
	int 13h
	
	cmp ah,0 
	mov bx,0
	jne over
	
	;显示提示
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
	
s:
	mov ah,0 
	int 16h
	
	mov  bx,0
	cmp ah,02h
	je	reboot
	cmp ah,03h
	je 	system
	cmp ah,04h
	je	clock
	cmp ah,05h
	je	setclock
	jmp	short s
	
setclock:
	add bx,4
clock:
	add bx,4
system:
	add bx,4
reboot:
	
	add bx,offset ker
	jmp dword ptr [bx] 
	
over:
	mov dx,0104h
	mov si,offset msg5 			
	call display 
	jmp short reboot
	
msg1 db '1) reset pc',0 ;显示信息 
msg2 db '2) start system',0 ;显示信息 
msg3 db '3) clock',0 ;显示信息 
msg4 db '4) set clock',0 ;显示信息 	
msg5 db 'error A',0 ;	
ker	dw 0h,07e0h,0,0800h,0,0820h,0,0840h	
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code ends 
end start 