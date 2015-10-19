assume cs:code
code segment
start:
;引导C盘system
	mov ax,0
	mov es,ax
	mov bx,7c00h
	mov al,1
	mov ch,0
	mov cl,1 
	mov dh,0 
	mov dl,80h
	mov	ah,2 
	int 13h
	
	mov ax,code
	mov ds,ax
	
	mov bx,offset boot
	jmp dword ptr [bx]
	
boot dw 7c00h,0	

code	ends
end start