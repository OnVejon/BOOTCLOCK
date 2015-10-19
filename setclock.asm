assume cs:code
code segment

start:	
	mov bx,0b800h
	mov es,bx
	mov bx,0 
	mov cx,2000
sub1s:
	mov byte ptr es:[bx],' '
	add bx,2
	loop sub1s
	
	
start0:
	
	mov bx,0b800h
	mov es,bx
	
	mov si,160*12+20
	mov al,8
	call near ptr readtime
	mov byte ptr es:[si+6],'\'
	add si,10
	mov al,7
	call near ptr readtime
	
	mov si,160*13+20
	mov al,4
	call near ptr readtime
	mov byte ptr es:[si+6],':'
	add si,10
	mov al,2
	call near ptr readtime
	
	
	mov bx,0860h
	mov	ds,bx 
	
	;mov word ptr top,0
sss:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;y	
	mov dh,12
	mov dl,11
	mov ah,2
	mov bh,0
	int 10h
	mov si,0
	call getstr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;d	
	mov dh,12
	mov dl,16
	mov ah,2
	mov bh,0
	int 10h
	mov si,0

	call getstr
ssss:	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;h
	mov si,0
	mov dh,13
	mov dl,11
	mov ah,2
	mov bh,0
	int 10h
	call getstr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov si,0
	mov dh,13
	mov dl,16
	mov ah,2
	mov bh,0
	int 10h
	call getstr
;;;;;;;;;;;;;;;;;;;;;;;;;
	mov si,160*12+20
	mov al,8
	call near ptr writeime
	add si,10
	mov al,7
	call near ptr writeime
	mov si,160*13+20
	mov al,4
	call near ptr writeime
	add si,10
	mov al,2
	call near ptr writeime

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	mov word ptr [bx],0 
	mov word ptr [bx+2],0820h 
	jmp dword ptr [bx]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;
writeime:
	out 70h,al
	mov ah,byte ptr es:[si]
	mov al,byte ptr es:[si+2]
	sub ah,30h
	sub al,30h
	mov cl,4
	shl ah,cl
	or al,ah
	out 71h,al
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
getstr:	
	push ax
	
getstrs:
	mov ah,0
	int 16h
	cmp al,30h
	jb nochar
	cmp al,39h
	ja nochar
	mov ah,0
	call charstack
	mov ah,2 
	call charstack
	jmp getstrs
	
nochar:
	cmp ah,0eh
	je backspace
	
	cmp ah,4bh
	je uenter
	cmp ah,48h
	je uenter
	cmp ah,1ch
	je enter
	cmp ah,1ch
	je enter
	jmp getstrs
backspace:
	mov ah,1 
	call charstack
	mov ah,2 
	call charstack
	jmp getstrs
	
enter:
	
	mov word ptr top,0
	mov al,0
	
	mov ah,2 
	call charstack
	pop ax
	ret
uenter:
	cmp dh,12
	jne	uenterok
	cmp	dl,16
	jne ssret
uenterok:
	mov ah,1 
	call charstack
	mov ah,1 
	call charstack
	mov bp,sp
	sub word ptr [bp],offset ssss-offset sss
ssret:
	pop ax
	ret
charstack:
	jmp short charstart
	
table	dw charpush,csharpop,charshow
top		dw 0

charstart:
	push bx
	push dx
	push di
	push es
	
	cmp ah,2
	ja sret
	mov bl,ah
	mov bh,0
	add bx,bx
	jmp word ptr table[bx]
	
charpush:
	cmp word ptr top,2
	jna	dat
charpush_n:
	mov bx,top
	mov [si][bx],al 
	inc top
	jmp sret

csharpop:
	cmp top,0
	je sret
	dec top
	mov bx,top
	mov al,[si][bx]
	jmp sret 
	
charshow:
	
	mov bx,0b800h
	mov es,bx
	mov al,160
	mov ah,0
	mul dh
	mov di,ax
	add dl,dl
	mov dh,0 
	add di,dx 
	
	mov bx,top
	
charshows:
	cmp bx,0
	jne noempty
	
	
	jmp sret
noempty:
	mov al,[si][bx]
	mov es:[di],al
	
	dec bx 
	sub di,2
	jmp charshows

sret:
	pop es
	pop di
	pop dx
	pop bx
	ret
dat:
	mov word ptr top,1
	mov bx,top
	dec bx
	mov ah,[si][bx+1]
	mov [si][bx],ah
	mov [si][bx+1],al 
	jmp sret
code ends
end start