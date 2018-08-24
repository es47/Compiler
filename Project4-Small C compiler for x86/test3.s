/* Data section */
	.section .data

	 .common c,4,4

	 .common b,4,4

	 .common a,4,4

L1:
	 .string "a = %d\n"
L2:
	 .string "a > 0\n"
L3:
	 .string "a = 0\n"
L4:
	 .string "a < 0\n"
L5:
	 .string "b = %d\n"
L6:
	 .string "b & 2\n"
L7:
	 .string "b !& 2\n"
L8:
	 .string "c = %d\n"
L9:
	 .string "c | 1\n"


/* Text section */
	.section .text
	.global main
	.type main,@function
main:
	 pushq %rbp
	 movq %rsp,%rbp
	 pushq %rbx
	 pushq %r12
	 pushq %r13
	 pushq %r14
	 pushq %r15
	 subq $8,%rsp

	 mov $1, %rsi
	 neg %rsi
	 mov %rsi,a(%rip)
	 mov a(%rip), %rsi
	 movq $L1,%rdi
	 call printf
	 mov a(%rip), %rsi
	 mov $0, %rdx
	 cmp %rsi, %rdx
	 jg loop1
	 movq $L2,%rdi
	 call printf
	 jmp loop2
loop1:
	 mov a(%rip), %rsi
	 mov $0, %rdx
	 cmp %rsi, %rdx
	 jne loop3
	 movq $L3,%rdi
	 call printf
	 jmp loop2
loop3:
	 movq $L4,%rdi
	 call printf
loop2:
	 mov $2, %rsi
	 mov %rsi,b(%rip)
	 mov b(%rip), %rsi
	 movq $L5,%rdi
	 call printf
	 mov b(%rip), %rsi
	 mov $2, %rdx
	 and %rsi, %rdx
	 mov $0, %r11
	 cmp %rdx, %r11
	 jg loop4
	 movq $L6,%rdi
	 call printf
	 jmp loop5
loop4:
	 movq $L7,%rdi
	 call printf
loop5:
	 mov $0, %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L8,%rdi
	 call printf
	 mov c(%rip), %rsi
	 mov $1, %rdx
	 or %rsi, %rdx
	 mov $0, %r11
	 cmp %rdx, %r11
	 jg loop6
	 movq $L9,%rdi
	 call printf
loop6:

	 addq $8,%rsp
	 popq %r15
	 popq %r14
	 popq %r13
	 popq %r12
	 popq %rbx
	 popq %rbp
	 ret
