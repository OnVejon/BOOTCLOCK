assume cs:code
code segment
	mov ax,0 
	mov [bx],ax
	mov ax,0ffffh
	mov [bx+2],ax
	jmp dword ptr [bx]
code ends
end