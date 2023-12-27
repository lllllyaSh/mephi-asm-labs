bits 64

section .data

sys_read 	equ 	0
sys_write	equ	1

sys_stdout	equ	1

sys_open	equ 	2
sys_close	equ	3
sys_create	equ	85

;permissions

O_RDONLY	equ	000000q


anslen	equ	3
ans	times	anslen	db	0

NL	db	0xa
space   db	0x20

open_success db "Opened successfully", 10, 0
write_success db "Recorded", 10, 0
close_success db "File is closed ", 10, 0

result db	"Result: ", 0
write_error db "Write error", 10, 0
close_error db "Close error", 10, 0
no_file db  "!!!no such file",10, 0
perm 	db	"Open file: permession denied", 10, 0
unknow  db	"Unknow open error", 10, 0
read_error  db  "!!read error", 10, 0
edit    db  "Want to rewrite [y/n]: ", 0
FD	dq	0; file descriptor
file	dq	0

bufferlen equ 100

var	dq	0
var_error	db	"error: give environment variable",10,0

section .bss

buffer resb	bufferlen+1
char	resb	1


section .text
global _start
_start:
	mov rax, rsp
	xor rcx, rcx
	pop r14
	cmp r14, 2
	je .file
	mov rdi, var_error
	call printf
	jmp .end
.file:
	pop r14
	pop r14
	mov [var], r14 ; [var] = переменная окружения
.loop:
	pop r14
	cmp r14, 0
	jne .loop

.next:
	pop r14
	cmp r14, 0
	je .end

	mov r11, [var]
	xor r12, r12
	mov r12b, byte[r11]
	
	cmp byte[r14], r12b ; сравнивааем первый символ если не совпало значит скорее всего не наша переменная
	jne .after
	mov rdi, r11
	mov rsi, r14
	call compare ; проверка на полное совпадение переменных
	cmp rax, 0 ; если rax > 0 значит переменные совпали и береме файл 
	jg .take_file

.after:; перезод к новой переменной
	cmp r14, 0; r14-переменная окружения
	jne .next
.take_file:
	inc rcx	
	lea r14, [r14+rcx] ; в rcx лежит длина переменной которую передали + '='
	mov qword[file], r14

	mov rdi, [file]
	call openfile
	cmp rax, 0
	jl .end
	mov qword[FD], rax

	mov rdi, buffer
	mov rsi, bufferlen
	call read
	
	mov rax, sys_close
	mov rdi, [FD]
	syscall

.end:	
	mov rax, 60
	mov rdi, 0
	syscall



;-------------------
writefile: ; rdi - buffer rsi-флаг след строки 
push rbp
mov rbp, rsp

    mov r12, rdi

    xor r10, r10
    mov r10b, byte[r12]

    cmp rsi, 0
    je .writec
    cmp byte[r12], ' '
    je .find_word_space

    cmp byte[r12], 10
    je .find_word_NL

.writec:;проверка на конец строчки и на согласную
    cmp byte[r12], 0
    je .end
	mov rdi, r12
	call consonant	; если rax=0 значит гласная, 1- согласная 
	cmp rax, 1
	je .skip

.write:
    mov rax, sys_write
    mov rdi, [FD]
    mov rsi, r12
	mov rdx, 1
    syscall
.skip:; если согласная скип
    inc r12
    cmp byte[r12], ' '
    jne .writec

.print_space_enter:; пишем пробел
    mov rax, sys_write
    mov rdi, [FD]
    mov rsi, r12
    mov rdx, 1
    syscall
	jmp .find_word_space



.new_string:

    mov rax, sys_write
    mov rdi, [FD]
    mov rsi, r12
    mov rdx, 1
    syscall
	inc r12

	cmp byte[r12], ' '
	je .find_word_space
	cmp byte[r12],10
	je .find_word_NL

	jmp .writec

.find_word_space:
    inc r12
    cmp byte[r12], ' '
    je .find_word_space
    mov r10b, byte[r12]
    jmp .writec

.find_word_NL:
    inc r12
    cmp byte[r12], 10
    je .find_word_NL
    mov r10b, byte[r12]
    jmp .writec

.end:

    leave
    ret

;------------
consonant: ; rdi- буква
push rbp
mov rbp, rsp
	mov al, byte[rdi]

	cmp al, 'b'
	je .false
	cmp al, 'c'
	je .false
	cmp al, 'd'
	je .false
	cmp al, 'f'
	je .false
	cmp al, 'g'
	je .false
	cmp al, 'h'
	je .false
	cmp al, 'j'
	je .false
	cmp al, 'k'
	je .false
	cmp al, 'l'
	je .false
	cmp al, 'm'
	je .false
	cmp al, 'n'
	je .false
	cmp al, 'p'
	je .false
	cmp al, 'q'
	je .false
	cmp al, 'r'
	je .false
	cmp al, 's'
	je .false
	cmp al, 't'
	je .false
	cmp al, 'v'
	je .false
	cmp al, 'w'
	je .false
	cmp al, 'x'
	je .false
	cmp al, 'z'
	je .false
	cmp al, 'B'
	je .false
	cmp al, 'C'
	je .false
	cmp al, 'D'
	je .false
	cmp al, 'F'
	je .false
	cmp al, 'G'
	je .false
	cmp al, 'H'
	je .false
	cmp al, 'J'
	je .false
	cmp al, 'K'
	je .false
	cmp al, 'L'
	je .false
	cmp al, 'M'
	je .false
	cmp al, 'N'
	je .false
	cmp al, 'P'
	je .false
	cmp al, 'Q'
	je .false
	cmp al, 'R'
	je .false
	cmp al, 'S'
	je .false
	cmp al, 'T'
	je .false
	cmp al, 'V'
	je .false
	cmp al, 'W'
	je .false
	cmp al, 'X'
	je .false
	cmp al, 'Z'
	je .false
	mov rax, 0
	leave 
	ret
.false:
	mov rax, 1
	leave
	ret



;---------------
read: ;rdi - buffer rsi-buffer_len
push rbp
mov rbp, rsp
    
	push rdi ;  сохраняем указатель на буффер
    mov r12, rdi ; buf
    mov r13, rsi ; max len
	
    xor r14, r14 
    mov ecx, 1 ; rcx если не ноль значит новая строка (чтобы избежать двойных пробелов или переходов на новую строку при печти в файл)
.readc:
    cmp r14, r13 
    ja .null
    
    mov byte[char],0
    mov rax, sys_read
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    push rcx
    syscall
    pop rcx
    mov al, [char]
    cmp al, 0
    je .done
    cmp al,byte[NL]
    je .return
    
    
    mov byte[r12], al
    mov al, 0
    mov byte[char], al
    inc r14
    inc r12
    jmp .readc
.return:; новая строка
    mov byte[r12], al
    inc r12
    mov rsi, rcx
    mov ecx, 1
    jmp .skip_xor
.null:; конец буфера
    mov rsi, rcx
    xor rcx, rcx
.skip_xor:; rcx- новая строчка или нет, хор когда буфер кончается
    mov al, 0
    mov [char], al
    mov byte[r12], 0
    mov rax, r14

    pop r12 ; берем сохраненный указатель на буффер
    push r12 ; сохраяем указатель на буффер для следующего циклы
    push r13 ; сохраняем размер буффера для след цикла
    push rcx
    mov rdi, r12
    
    call writefile ; rdi - buff rsi-ecx  
    xor r14, r14
    pop rcx
    pop r13
    pop r12
    push r12
    jmp .readc

.done:

    leave
    ret
;---------------


;------------
openfile:

	mov rax, sys_open
	mov rsi, 00001q
;	mov rsi, 641  
;	mov rdx, 0644
	syscall	

	cmp rax, 0
	jl .openerr
    push rdi
 
    push rax

    mov rdi, edit
    call printf

 
    mov rdi, buffer
    mov rsi, bufferlen
    call read_char
  
    pop rcx
    pop r10
    mov eax, 'y'
    cmp [buffer], eax
    jne .done
    mov rax, rcx
    mov rdi, rax
    mov eax, sys_close                  
    syscall

    mov rdi, r10
    mov rax, 2                   ; Системный вызов 'open'
    mov rsi, 641                 ; Флаги доступа и режим открытия (O_WRONLY | O_CREAT | O_TRUNC)
    mov rdx, 0644                ; Режим доступа к файлу
    syscall
    
    push rax
    mov rdi, open_success
    call printf
    pop rax
    ret

.openerr:
	cmp rax, -2
	je .no_file

	cmp rax, -13
	jne .unknow
	
	
	mov rdi, perm
	push rax
	call printf
	pop rax
	ret
.unknow:
	mov rdi, unknow
	push rax
	call printf
	pop rax
	ret
.no_file:
	mov rax, 85
	mov rsi, 00600q
	syscall

	mov rax, sys_open
	mov rsi, 000001q
	syscall
	push rax
	mov rdi, open_success
	call printf
	pop rax

	ret
.done:
	mov rax, -1
    ret
;--------------

read_char:; при открытии файл y\n
push rbp
mov rbp, rsp
    
    mov r12, rdi ; buf
    mov r13, rsi ; max len

    xor r14, r14 
.readc:
    cmp r14, r13 
    ja .return
    mov rax, sys_read
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall
    mov al, [char]
    cmp al, 0
    je .done
    cmp al,byte[NL]
    je .return
    
    
    mov byte[r12], al
    mov al, 0
    mov byte[char], al
    inc r14
    inc r12
    jmp .readc
.return:
    mov al, 0
    mov [char], al
    mov byte[r12], 0
    mov rax, r14
    leave
    ret
.done:
    mov rax, -1
    leave
    ret


;--------------
compare:; переменная окружения сравниается с перем из стека
push rbp
mov rbp, rsp
mov rax, 1
xor rcx, rcx
.compare:
	
	inc rdi
	inc rsi
	inc rcx

	cmp byte[rsi], 61; 61-символ =
	je .check_rdi
	mov r10b, byte[rsi]
	cmp byte[rdi], r10b
	jne .ret
	jmp .compare

.check_rdi:
	cmp byte[rdi], 0
	je .good
	
.ret:
	mov rax, -1
	leave
	ret
.good:
	leave
	ret
;-----------------


printf: ; rdi - string, that will be shown; uses r12, rdx, rax, rsi, rdi
	mov r12, rdi
	xor rdx, rdx
.string_loop:; пока не 0 в концк строчки
	cmp byte[r12], 0
	je .return
	inc rdx
	inc r12
	jmp .string_loop
.return:
	mov rax, 1
	mov rsi, rdi
	mov rdi, 1
	syscall

	ret

