bits 64

section .data
section .text

global func
; rdi=width rsi=height rdx=bytes rcx-старое изображение r8-новое изображение
func:
push rbp
mov rbp, rsp
push r10
push r11
push r12
push r13
	mov r9, rdx; r9 = bytes
	xor r10, r10; для цикла по heigth
	xor r11, r11; для цикла по width
	xor rbx, rbx
	xor r13, r13
.loop1:
	cmp r11, rdi; for(i = 0; i < width; ++i)
	je .loop2
	xor r12, r12; r12 = pos
.loop3:
	cmp r12, r9
	je .end

	mov rax, r10 ; rax = j
	inc rax
	mul rdi ; (j + 1) * width
	sub rax, r11
	dec rax ; ((j + 1) * width - i - 1)
	mul r9 ; ((j + 1) * width - i - 1) * bytes
	add rax, r12 ; +pos

	mov rbx, rax ; в rbx результат вычислений

	mov rax, r10 ; rax = j
	mul rdi ; j * width
	add rax, r11 ; j * width + i
	mul r9 ; (j * width + i) * bytes
	add rax, r12 ; + pos


	mov r13b, byte[rcx+rbx]
	mov byte[r8+rax], r13b
	inc r12
	jmp .loop3

.end:
	inc r11
	jmp .loop1

.loop2:
    ; for(j = 0; j < heigth; ++j)
	inc r10
	cmp r10, rsi
	je .exit
	xor rbx, rbx
	xor r11, r11
	jmp .loop1
.exit:
	pop r13
	pop r12
	pop r11
	pop r10
	leave
	ret
