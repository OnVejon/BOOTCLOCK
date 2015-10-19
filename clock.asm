assume cs:code

code segment
start:	
	call sub1
	
	push cs
	pop ds
	mov si,offset int9
	
	mov ax,0
	mov es,ax
	mov di,204h
	
	mov cx,offset int9end-offset int9
	cld
	rep movsb
	
	push es:[9*4]
	pop es:[200h]
	push es:[9*4+2]
	pop es:[202h]

	cli;屏蔽开始
	mov word ptr es:[9*4],204h
	mov word ptr es:[9*4+2],0
	sti;屏蔽结束
start0:
	
	mov bx,0b800h
	mov es,bx
	
	mov si,160*12+20
	mov byte ptr es:[si],'2'
	add si,2
	mov byte ptr es:[si],'0'
	add si,2
	
	mov al,9
	call near ptr readtime 
	mov byte ptr es:[si+4],'/'
	add si,6
	mov al,8
	call near ptr readtime
	mov byte ptr es:[si+4],'/'
	add si,6
	mov al,7
	call near ptr readtime
	add si,8
	mov al,4
	call near ptr readtime
	mov byte ptr es:[si+4],':'
	add si,6
	mov al,2
	call near ptr readtime
	mov byte ptr es:[si+4],':'
	;秒
	add si,6
	mov al,0
	call near ptr readtime
	
	
	

	jmp short start0

readtime:
	out 70h,al
	in al,71h
	
	mov ah,al
	mov cl,4
	shr ah,cl
	and al,00001111b
	
	add ah,30h
	add al,30h
	
	mov byte ptr es:[si],ah
	mov byte ptr es:[si+2],al
	ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
sub1:
	push bx
	push cx
	push es
	mov bx,0b800h
	mov es,bx
	mov bx,0 
	mov cx,2000
sub1s:
	mov byte ptr es:[bx],' '
	add bx,2
	loop sub1s
	pop es
	pop cx
	pop bx
	ret	
;;;;;;;;;;;;;;;;;;;;;;;	
int9:
	push ax
	push bx
	push cx
	push es
	
	in al,60h
	
	pushf
	
	call dword ptr cs:[200h]
	cmp al,01h
	je utall
	cmp al,3bh
	jne int9ret
	
	mov ax,0b800h
	mov es,ax
	mov bx,1 
	mov cx,2000
s:
	inc byte ptr es:[bx]
	add bx,2
	loop s
	
int9ret:
	pop es
	pop cx
	pop bx
	pop ax
	iret
utall:
;;;;;;;;;;;;;;;;;;;;;;
	add sp,14
	mov ax,0b800h
	mov es,ax
	mov bx,0 
	mov cx,2000
s0:
	mov byte ptr es:[bx],' '
	add bx,2
	loop s0
	mov bx,1 
	mov cx,2000
s1:
	mov byte ptr es:[bx],00000111b
	add bx,2
	loop s1
;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	push cs:[9*4]
	
	push cs:[9*4+2]
	cli;屏蔽开始
	mov ax,cs:[200h]
	mov word ptr cs:[9*4],ax
	mov ax,cs:[200h+2]
	mov word ptr cs:[9*4+2],ax
	sti;屏蔽结束
	pop cs:[200h]
	pop cs:[202h]
;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,0
	mov es,ax
	mov bx,200h	
	mov word ptr es:[bx],7c00h
	mov word ptr es:[bx+2],0 
	
	jmp dword ptr es:[bx]
int9end:nop		

code ends
end start