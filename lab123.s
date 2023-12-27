section .data
res:
	dq 0
a:
	dw 3
b:
	dw 2
c:
	dw 3
d:
	dw 4
e:
	dd 5

section .text
global _start

over:
	mov eax, 60
	mov edi, 1
	syscall
error:
	mov eax, 60
	mov edi, 2
	syscall
_start:
	xor rax, rax
	movzx eax, word[a]
	mul eax ; a^2
	movzx rbx, word[c]
	mul rbx
	mov r8, rax ; a^2*c
	xor rax, rax
	movzx eax, word[b]
	mul eax ; b^2
	movzx rdx, word[d]
	mul rdx ; b^2*d
	sub r8, rax
	jc over
	movzx rdx, word[e]
	add r8, rdx
	jc over
	jc error ; denominator
	movzx eax, word[a]
	mul eax
	movzx rbx, word[a]
	mul rbx
	jc over
	mov rcx, rax; a^3
	movzx eax, word[b]
	mul rax
	movzx rbx, word[b]
	mul rbx ; b^3
	add rcx, rax ; a^3+b^3
	xor rdx, rdx
	mov rax, rcx
	div r8
	mov [res], rax
	mov eax, 60
	xor edi, edi
	syscall
 
