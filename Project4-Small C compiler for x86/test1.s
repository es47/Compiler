/* Data section */
	.section .data

	 .common c,4,4

	 .common b,4,4

	 .common a,4,4

L1:
	 .string "a = %d\n"
L2:
	 .string "b = %d\n"
L3:
	 .string "-a = %d\n"
L4:
	 .string "-b = %d\n"
L5:
	 .string "a - b = %d\n"
L6:
	 .string "a + b = %d\n"
L7:
	 .string "a * b = %d\n"
L8:
	 .string "b / a = %d\n"


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
	 mov %rsi,a(%rip)
	 mov a(%rip), %rsi
	 movq $L1,%rdi
	 call printf
	 mov $2, %rsi
	 mov %rsi,b(%rip)
	 mov b(%rip), %rsi
	 movq $L2,%rdi
	 call printf
	 mov a(%rip), %rsi
	 neg %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L3,%rdi
	 call printf
	 mov b(%rip), %rsi
	 neg %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L4,%rdi
	 call printf
	 mov $1, %rsi
	 mov %rsi,a(%rip)
	 mov $2, %rsi
	 mov %rsi,b(%rip)
	 mov a(%rip), %rsi
	 mov b(%rip), %rdx
	 sub %rdx, %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L5,%rdi
	 call printf
	 mov $1, %rsi
	 mov %rsi,a(%rip)
	 mov $2, %rsi
	 mov %rsi,b(%rip)
	 mov b(%rip), %rsi
	 mov a(%rip), %rdx
	 add %rdx, %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L6,%rdi
	 call printf
	 mov $1, %rsi
	 mov %rsi,a(%rip)
	 mov $2, %rsi
	 mov %rsi,b(%rip)
	 mov a(%rip), %rsi
	 mov b(%rip), %rdx
	 imul %rdx, %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L7,%rdi
	 call printf
	 mov $1, %rsi
	 mov %rsi,a(%rip)
	 mov $2, %rsi
	 mov %rsi,b(%rip)
	 mov b(%rip), %rsi
	 mov a(%rip), %rdx
	 mov %rsi, %rax
	 mov %rdx, %r10
	 mov $0, %rdx
	 mov $0, %rcx
	 mov $0, %rbx
	 idiv %r10
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L8,%rdi
	 call printf

	 addq $8,%rsp
	 popq %r15
	 popq %r14
	 popq %r13
	 popq %r12
	 popq %rbx
	 popq %rbp
	 ret
