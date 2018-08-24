/* Data section */
	.section .data

	 .common b,4,4

	 .common a,4,4

L1:
	 .string "%d\n"


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

	 mov $0, %rsi
	 mov %rsi,a(%rip)
loop1:
	 mov a(%rip), %rsi
	 mov $10, %rdx
	 cmp %rsi, %rdx
	 jle loop2
	 mov a(%rip), %rcx
	 mov $1, %r8
	 add %r8, %rcx
	 mov %rcx,a(%rip)
	 mov a(%rip), %rsi
	 movq $L1,%rdi
	 call printf
	 jmp loop1
loop2:

	 addq $8,%rsp
	 popq %r15
	 popq %r14
	 popq %r13
	 popq %r12
	 popq %rbx
	 popq %rbp
	 ret
