bits 64

section .data

matrix:
    dq  5, 13, 23, 5, 6
    dq  45, 23, 4, 5 ,6
    dq  9, 0, 7 ,4, 3
    dq  1, 2 ,3 ,4 ,42


mass:
   dq 0,0,0,0

m:
    dd 4
n:
    dd 5

section .text

global _start

_start:
	mov eax, 2
	cmp [m], eax
	jl .exit
	call set_mass
	call InsertSort
	mov rax, 60
.exit:
	mov rax, 60
	mov rdi, 0
	syscall








BinarySearch:
	mov eax, edi
	add eax, esi
	shr eax, 1
	cmp rcx, [mass+8*eax]

	%ifdef min
		jg .big
		jl .lit
	%else
		jl .big
		jg .lit
	%endif

	inc eax
	ret
.big:
	cmp rsi, rax
	je .big_ret
	inc eax
	mov edi, eax
	call BinarySearch
	ret
.lit:
	cmp edi, eax
	je .lit_ret
	dec eax
	mov esi, eax
	call BinarySearch
	ret
.lit_ret:
	ret
.big_ret:
	inc eax
	ret



InsertSort:
	xor esi ,esi
	inc esi ; right var

.loop:
	push rsi
	mov edi, 0 ; start position (left var)
	mov rcx, [mass+8*esi] ; selected var
	dec esi
	call BinarySearch
	pop rsi ; right
	mov ebx, esi
	mov edi, ebx
	dec edi
.select:
	cmp eax, ebx ; ebx
	je .cont
	mov r10, [mass+edi*8]
	mov [mass+ebx*8], r10

	push rdi
	push rsi
	push rcx
	mov rsi, rbx;  4 3 5
	push rax
	push rdx

	call swap_row

	pop rdx
	pop rax
	pop rcx
	pop rsi
	pop rdi

	dec edi
	dec ebx
	jmp .select
.cont:
	mov [mass+8*eax], rcx

	inc esi
	cmp esi, [m]
	jne .loop

	ret

swap_row: ; rdi - first , rsi - second
	xor ecx, ecx
	mov ecx, [n]
	mov rax, rdi
	mul rcx
	mov rdi, rax

	mov rax, rsi
	mul rcx
	mov rsi, rax
.loop:
	mov r11, [matrix+8*rsi]
	mov r10, [matrix+8*rdi]
	mov [matrix+8*rdi], r11
	mov [matrix+8*rsi], r10
	inc rsi
	inc edi
	loop .loop

	ret


set_mass:
	mov esi, [m]
	xor edi, edi
	mov ecx, [n]
.settings:
	xor edx, edx
	xor rax, rax
.loop:

	add  rax, [matrix+8*edx]
	inc edx
	loop .loop
.check:
	mov [mass+edi*8], rax
	dec esi
	cmp esi, 0
	je .ret
	inc edi
	xor rax, rax
	mov ecx, [n]
	jmp .loop

.ret:
	ret
