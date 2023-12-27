bits 64

extern fopen
extern fclose
extern printf
extern scanf
extern pow
extern fprintf

section .data

enter_str	db	"Enter x, alpha, accuracy ", 10, 0
format_enter	db	"%lf %lf %lf" ,0

file_format	db	"%d : %lf",10 ,0
result_format	db	"(1+%lf)^%lf = %lf", 10, 0
my_result	db	"my(1+%lf)^%lf = %lf ", 10 , 0
error_file	db	"open file error", 10 ,0

file_d	db	0
file_flag	db	"w",0

mone	dq	-1.0
one 	dq 	1.0
section .bss
file_name resb 16

section .text
global main

x equ 8
alpha equ 8+x
res equ alpha+8
ac equ res+8

global main

main:
push rbp
mov rbp, rsp
sub rsp, ac

	cmp rdi, 2
	jne .exit
	mov rdi, [rsi+8]
	mov [file_name],  rdi
	mov rdi, enter_str
	xor rax, rax
	call printf
	mov rdi, format_enter
	lea rsi, [rbp-x]
	lea rdx, [rbp-alpha]
	lea rcx, [rbp-ac]
	xor eax, eax
	call scanf
	
	movsd xmm0, qword[rbp-x]
	addsd xmm0, qword[one]
	movsd xmm1, qword[rbp-alpha]
	call pow
	movsd qword[rbp-res], xmm0
	movsd xmm2, xmm0
	movsd xmm1, qword[rbp-alpha]
	movsd xmm0, qword[rbp-x]
	mov rdi, result_format 
	mov eax, 3
	call printf
	

	movsd xmm0, [rbp-x]
	movsd xmm1, [rbp-alpha]
	movsd xmm2, [rbp-ac]
	mov rdi, [file_name]
	call my_exp
	
	cmp rax, 0
	jl .exit
	
	mov rdi, my_result
	movsd xmm2, xmm0
	movsd xmm1, qword[rbp-alpha]
	movsd xmm0, qword[rbp-x]
	mov eax, 3
	call printf
	
.exit:
	add rsp, 8
	add rsp, ac
	leave
	ret
	


zero dq 0

n1 equ 8
x1 equ n1+8
xn equ x1+8
divv equ xn+8
acc equ divv+8
sum equ acc+8
num equ sum+8
tmp equ num+8
alpha1 equ tmp+8

my_exp:
push rbp
mov rbp, rsp
sub rsp, alpha1
sub rsp, 8
	movsd xmm3, qword[one]
	movsd xmm4, qword[zero]
	movsd [rbp-n1], xmm3
	movsd qword[rbp-x1], xmm0
	movsd qword[rbp-xn], xmm0
	movsd qword[rbp-acc], xmm2
	movsd qword[rbp-divv], xmm1
	movsd qword[rbp-sum], xmm3
	movsd qword[rbp-num],xmm4
	movsd qword[rbp-alpha1], xmm1	
	
	mov rdi, [file_name]
	mov rsi, file_flag 
	call fopen

	cmp rax, 0
	jl .error
	mov qword[file_d], rax

.m0:

	movsd xmm0, qword[rbp-divv]
	movsd xmm1, qword[rbp-xn]
	mulsd xmm1, xmm0
	
	

	movsd xmm3, qword[rbp-sum]
	addsd xmm3, xmm1
	movsd qword[rbp-sum], xmm3
	movsd qword[rbp-tmp], xmm1
	
	movsd xmm0, qword[rbp-xn]
	movsd xmm5, qword[rbp-x1]
	mulsd xmm0, xmm5
	movsd qword[rbp-xn], xmm0
	
	movsd xmm0, qword[rbp-divv]
	movsd xmm1, qword[rbp-alpha1]
	subsd xmm1, qword[one]
	mulsd xmm0, xmm1
	
	movsd qword[rbp-alpha1], xmm1

	movsd xmm1, qword[rbp-n1]
	addsd xmm1, qword[one]
	divsd xmm0, xmm1
	movsd qword[rbp-divv], xmm0
	movsd qword[rbp-n1], xmm1
	
	movsd xmm0, qword[rbp-n1]
	cvtsd2si rdx, xmm0
	dec rdx	

	mov rdi, [file_d]	
	mov rsi, file_format
	movsd xmm0, qword[rbp-sum]
	mov eax, 1
	call fprintf

	movsd xmm0, qword[rbp-acc]
	movsd xmm1, qword[rbp-tmp]
	movsd xmm2, qword[rbp-num]
	movsd qword[rbp-num], xmm1	
	ucomisd xmm2, xmm1
	jb .neg
	subsd xmm2, xmm1
	movsd xmm1, xmm2
	jmp .check
.neg:
	subsd xmm1, xmm2
.check:	
	ucomisd xmm1, xmm0
	ja .m0
	
	mov rdi, [file_d]
	call fclose
	mov rax, 1
	jmp .exit
.error:
	mov rdi, error_file
	xor rax, rax
	call printf
	mov rax, -1
	add rsp, tmp
	leave
	ret
.exit:
	movsd xmm0, qword[rbp-sum]
	add rsp, alpha1
	add rsp, 8
	leave
	ret 
