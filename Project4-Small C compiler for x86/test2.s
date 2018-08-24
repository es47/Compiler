/* Data section */
	.section .data

	 .common c,4,4

	 .common b,4,4

	 .common a,4,4

L1:
	 .string "a = %d\n"
L2:
	 .string "a++ = %d\n"
L3:
	 .string "b = %d\n"
L4:
	 .string "b++ = %d\n"
L5:
	 .string "c = %d\n"
L6:
	 .string "c-- = %d\n"


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

	 mov $2, %rsi
	 mov %rsi,a(%rip)
	 mov a(%rip), %rsi
	 movq $L1,%rdi
	 call printf
	 mov a(%rip), %rsi
	 inc %rsi
	 mov %rsi,a(%rip)
	 mov a(%rip), %rsi
	 movq $L2,%rdi
	 call printf
	 mov $5, %rsi
	 mov %rsi,b(%rip)
	 mov b(%rip), %rsi
	 movq $L3,%rdi
	 call printf
	 mov b(%rip), %rsi
	 inc %rsi
	 mov %rsi,b(%rip)
	 mov b(%rip), %rsi
	 movq $L4,%rdi
	 call printf
	 mov $0, %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L5,%rdi
	 call printf
	 mov c(%rip), %rsi
	 dec %rsi
	 mov %rsi,c(%rip)
	 mov c(%rip), %rsi
	 movq $L6,%rdi
	 call printf

	 addq $8,%rsp
	 popq %r15
	 popq %r14
	 popq %r13
	 popq %r12
	 popq %rbx
	 popq %rbp
	 ret
