.text	

.globl	x25519_fe51_mul
.def	x25519_fe51_mul;	.scl 2;	.type 32;	.endef
.p2align	5
x25519_fe51_mul:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_x25519_fe51_mul:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	leaq	-40(%rsp),%rsp

.Lfe51_mul_body:

	movq	0(%rsi),%rax
	movq	0(%rdx),%r11
	movq	8(%rdx),%r12
	movq	16(%rdx),%r13
	movq	24(%rdx),%rbp
	movq	32(%rdx),%r14

	movq	%rdi,32(%rsp)
	movq	%rax,%rdi
	mulq	%r11
	movq	%r11,0(%rsp)
	movq	%rax,%rbx
	movq	%rdi,%rax
	movq	%rdx,%rcx
	mulq	%r12
	movq	%r12,8(%rsp)
	movq	%rax,%r8
	movq	%rdi,%rax
	leaq	(%r14,%r14,8),%r15
	movq	%rdx,%r9
	mulq	%r13
	movq	%r13,16(%rsp)
	movq	%rax,%r10
	movq	%rdi,%rax
	leaq	(%r14,%r15,2),%rdi
	movq	%rdx,%r11
	mulq	%rbp
	movq	%rax,%r12
	movq	0(%rsi),%rax
	movq	%rdx,%r13
	mulq	%r14
	movq	%rax,%r14
	movq	8(%rsi),%rax
	movq	%rdx,%r15

	mulq	%rdi
	addq	%rax,%rbx
	movq	16(%rsi),%rax
	adcq	%rdx,%rcx
	mulq	%rdi
	addq	%rax,%r8
	movq	24(%rsi),%rax
	adcq	%rdx,%r9
	mulq	%rdi
	addq	%rax,%r10
	movq	32(%rsi),%rax
	adcq	%rdx,%r11
	mulq	%rdi
	imulq	$19,%rbp,%rdi
	addq	%rax,%r12
	movq	8(%rsi),%rax
	adcq	%rdx,%r13
	mulq	%rbp
	movq	16(%rsp),%rbp
	addq	%rax,%r14
	movq	16(%rsi),%rax
	adcq	%rdx,%r15

	mulq	%rdi
	addq	%rax,%rbx
	movq	24(%rsi),%rax
	adcq	%rdx,%rcx
	mulq	%rdi
	addq	%rax,%r8
	movq	32(%rsi),%rax
	adcq	%rdx,%r9
	mulq	%rdi
	imulq	$19,%rbp,%rdi
	addq	%rax,%r10
	movq	8(%rsi),%rax
	adcq	%rdx,%r11
	mulq	%rbp
	addq	%rax,%r12
	movq	16(%rsi),%rax
	adcq	%rdx,%r13
	mulq	%rbp
	movq	8(%rsp),%rbp
	addq	%rax,%r14
	movq	24(%rsi),%rax
	adcq	%rdx,%r15

	mulq	%rdi
	addq	%rax,%rbx
	movq	32(%rsi),%rax
	adcq	%rdx,%rcx
	mulq	%rdi
	addq	%rax,%r8
	movq	8(%rsi),%rax
	adcq	%rdx,%r9
	mulq	%rbp
	imulq	$19,%rbp,%rdi
	addq	%rax,%r10
	movq	16(%rsi),%rax
	adcq	%rdx,%r11
	mulq	%rbp
	addq	%rax,%r12
	movq	24(%rsi),%rax
	adcq	%rdx,%r13
	mulq	%rbp
	movq	0(%rsp),%rbp
	addq	%rax,%r14
	movq	32(%rsi),%rax
	adcq	%rdx,%r15

	mulq	%rdi
	addq	%rax,%rbx
	movq	8(%rsi),%rax
	adcq	%rdx,%rcx
	mulq	%rbp
	addq	%rax,%r8
	movq	16(%rsi),%rax
	adcq	%rdx,%r9
	mulq	%rbp
	addq	%rax,%r10
	movq	24(%rsi),%rax
	adcq	%rdx,%r11
	mulq	%rbp
	addq	%rax,%r12
	movq	32(%rsi),%rax
	adcq	%rdx,%r13
	mulq	%rbp
	addq	%rax,%r14
	adcq	%rdx,%r15

	movq	32(%rsp),%rdi
	jmp	.Lreduce51
.Lfe51_mul_epilogue:

.LSEH_end_x25519_fe51_mul:

.globl	x25519_fe51_sqr
.def	x25519_fe51_sqr;	.scl 2;	.type 32;	.endef
.p2align	5
x25519_fe51_sqr:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_x25519_fe51_sqr:
	movq	%rcx,%rdi
	movq	%rdx,%rsi


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	leaq	-40(%rsp),%rsp

.Lfe51_sqr_body:

	movq	0(%rsi),%rax
	movq	16(%rsi),%r15
	movq	32(%rsi),%rbp

	movq	%rdi,32(%rsp)
	leaq	(%rax,%rax,1),%r14
	mulq	%rax
	movq	%rax,%rbx
	movq	8(%rsi),%rax
	movq	%rdx,%rcx
	mulq	%r14
	movq	%rax,%r8
	movq	%r15,%rax
	movq	%r15,0(%rsp)
	movq	%rdx,%r9
	mulq	%r14
	movq	%rax,%r10
	movq	24(%rsi),%rax
	movq	%rdx,%r11
	imulq	$19,%rbp,%rdi
	mulq	%r14
	movq	%rax,%r12
	movq	%rbp,%rax
	movq	%rdx,%r13
	mulq	%r14
	movq	%rax,%r14
	movq	%rbp,%rax
	movq	%rdx,%r15

	mulq	%rdi
	addq	%rax,%r12
	movq	8(%rsi),%rax
	adcq	%rdx,%r13

	movq	24(%rsi),%rsi
	leaq	(%rax,%rax,1),%rbp
	mulq	%rax
	addq	%rax,%r10
	movq	0(%rsp),%rax
	adcq	%rdx,%r11
	mulq	%rbp
	addq	%rax,%r12
	movq	%rbp,%rax
	adcq	%rdx,%r13
	mulq	%rsi
	addq	%rax,%r14
	movq	%rbp,%rax
	adcq	%rdx,%r15
	imulq	$19,%rsi,%rbp
	mulq	%rdi
	addq	%rax,%rbx
	leaq	(%rsi,%rsi,1),%rax
	adcq	%rdx,%rcx

	mulq	%rdi
	addq	%rax,%r10
	movq	%rsi,%rax
	adcq	%rdx,%r11
	mulq	%rbp
	addq	%rax,%r8
	movq	0(%rsp),%rax
	adcq	%rdx,%r9

	leaq	(%rax,%rax,1),%rsi
	mulq	%rax
	addq	%rax,%r14
	movq	%rbp,%rax
	adcq	%rdx,%r15
	mulq	%rsi
	addq	%rax,%rbx
	movq	%rsi,%rax
	adcq	%rdx,%rcx
	mulq	%rdi
	addq	%rax,%r8
	adcq	%rdx,%r9

	movq	32(%rsp),%rdi
	jmp	.Lreduce51

.p2align	5
.Lreduce51:
	movq	$0x7ffffffffffff,%rbp

	movq	%r10,%rdx
	shrq	$51,%r10
	shlq	$13,%r11
	andq	%rbp,%rdx
	orq	%r10,%r11
	addq	%r11,%r12
	adcq	$0,%r13

	movq	%rbx,%rax
	shrq	$51,%rbx
	shlq	$13,%rcx
	andq	%rbp,%rax
	orq	%rbx,%rcx
	addq	%rcx,%r8
	adcq	$0,%r9

	movq	%r12,%rbx
	shrq	$51,%r12
	shlq	$13,%r13
	andq	%rbp,%rbx
	orq	%r12,%r13
	addq	%r13,%r14
	adcq	$0,%r15

	movq	%r8,%rcx
	shrq	$51,%r8
	shlq	$13,%r9
	andq	%rbp,%rcx
	orq	%r8,%r9
	addq	%r9,%rdx

	movq	%r14,%r10
	shrq	$51,%r14
	shlq	$13,%r15
	andq	%rbp,%r10
	orq	%r14,%r15

	leaq	(%r15,%r15,8),%r14
	leaq	(%r15,%r14,2),%r15
	addq	%r15,%rax

	movq	%rdx,%r8
	andq	%rbp,%rdx
	shrq	$51,%r8
	addq	%r8,%rbx

	movq	%rax,%r9
	andq	%rbp,%rax
	shrq	$51,%r9
	addq	%r9,%rcx

	movq	%rax,0(%rdi)
	movq	%rcx,8(%rdi)
	movq	%rdx,16(%rdi)
	movq	%rbx,24(%rdi)
	movq	%r10,32(%rdi)

	movq	40(%rsp),%r15

	movq	48(%rsp),%r14

	movq	56(%rsp),%r13

	movq	64(%rsp),%r12

	movq	72(%rsp),%rbx

	movq	80(%rsp),%rbp

	leaq	88(%rsp),%rsp

.Lfe51_sqr_epilogue:
	movq	8(%rsp),%rdi
	movq	16(%rsp),%rsi
	.byte	0xf3,0xc3

.LSEH_end_x25519_fe51_sqr:

.globl	x25519_fe51_mul121666
.def	x25519_fe51_mul121666;	.scl 2;	.type 32;	.endef
.p2align	5
x25519_fe51_mul121666:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_x25519_fe51_mul121666:
	movq	%rcx,%rdi
	movq	%rdx,%rsi


	pushq	%rbp

	pushq	%rbx

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	leaq	-40(%rsp),%rsp

.Lfe51_mul121666_body:
	movl	$121666,%eax

	mulq	0(%rsi)
	movq	%rax,%rbx
	movl	$121666,%eax
	movq	%rdx,%rcx
	mulq	8(%rsi)
	movq	%rax,%r8
	movl	$121666,%eax
	movq	%rdx,%r9
	mulq	16(%rsi)
	movq	%rax,%r10
	movl	$121666,%eax
	movq	%rdx,%r11
	mulq	24(%rsi)
	movq	%rax,%r12
	movl	$121666,%eax
	movq	%rdx,%r13
	mulq	32(%rsi)
	movq	%rax,%r14
	movq	%rdx,%r15

	jmp	.Lreduce51
.Lfe51_mul121666_epilogue:

.LSEH_end_x25519_fe51_mul121666:
.globl	x25519_fe64_eligible
.def	x25519_fe64_eligible;	.scl 2;	.type 32;	.endef
.p2align	5
x25519_fe64_eligible:

	xorl	%eax,%eax
	.byte	0xf3,0xc3



.globl	x25519_fe64_mul
.def	x25519_fe64_mul;	.scl 2;	.type 32;	.endef
.globl	x25519_fe64_sqr
.globl	x25519_fe64_mul121666
.globl	x25519_fe64_add
.globl	x25519_fe64_sub
.globl	x25519_fe64_tobytes
x25519_fe64_mul:
x25519_fe64_sqr:
x25519_fe64_mul121666:
x25519_fe64_add:
x25519_fe64_sub:
x25519_fe64_tobytes:

.byte	0x0f,0x0b
	.byte	0xf3,0xc3


.byte	88,50,53,53,49,57,32,112,114,105,109,105,116,105,118,101,115,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,104,116,116,112,115,58,47,47,103,105,116,104,117,98,46,99,111,109,47,100,111,116,45,97,115,109,62,0


.def	short_handler;	.scl 3;	.type 32;	.endef
.p2align	4
short_handler:
	pushq	%rsi
	pushq	%rdi
	pushq	%rbx
	pushq	%rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushfq
	subq	$64,%rsp

	movq	120(%r8),%rax
	movq	248(%r8),%rbx

	movq	8(%r9),%rsi
	movq	56(%r9),%r11

	movl	0(%r11),%r10d
	leaq	(%rsi,%r10,1),%r10
	cmpq	%r10,%rbx
	jb	.Lcommon_seh_tail

	movq	152(%r8),%rax
	jmp	.Lcommon_seh_tail


.def	full_handler;	.scl 3;	.type 32;	.endef
.p2align	4
full_handler:
	pushq	%rsi
	pushq	%rdi
	pushq	%rbx
	pushq	%rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushfq
	subq	$64,%rsp

	movq	120(%r8),%rax
	movq	248(%r8),%rbx

	movq	8(%r9),%rsi
	movq	56(%r9),%r11

	movl	0(%r11),%r10d
	leaq	(%rsi,%r10,1),%r10
	cmpq	%r10,%rbx
	jb	.Lcommon_seh_tail

	movq	152(%r8),%rax

	movl	4(%r11),%r10d
	leaq	(%rsi,%r10,1),%r10
	cmpq	%r10,%rbx
	jae	.Lcommon_seh_tail

	movl	8(%r11),%r10d
	leaq	(%rax,%r10,1),%rax

	movq	-8(%rax),%rbp
	movq	-16(%rax),%rbx
	movq	-24(%rax),%r12
	movq	-32(%rax),%r13
	movq	-40(%rax),%r14
	movq	-48(%rax),%r15
	movq	%rbx,144(%r8)
	movq	%rbp,160(%r8)
	movq	%r12,216(%r8)
	movq	%r13,224(%r8)
	movq	%r14,232(%r8)
	movq	%r15,240(%r8)

.Lcommon_seh_tail:
	movq	8(%rax),%rdi
	movq	16(%rax),%rsi
	movq	%rax,152(%r8)
	movq	%rsi,168(%r8)
	movq	%rdi,176(%r8)

	movq	40(%r9),%rdi
	movq	%r8,%rsi
	movl	$154,%ecx
.long	0xa548f3fc

	movq	%r9,%rsi
	xorq	%rcx,%rcx
	movq	8(%rsi),%rdx
	movq	0(%rsi),%r8
	movq	16(%rsi),%r9
	movq	40(%rsi),%r10
	leaq	56(%rsi),%r11
	leaq	24(%rsi),%r12
	movq	%r10,32(%rsp)
	movq	%r11,40(%rsp)
	movq	%r12,48(%rsp)
	movq	%rcx,56(%rsp)
	call	*__imp_RtlVirtualUnwind(%rip)

	movl	$1,%eax
	addq	$64,%rsp
	popfq
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	.byte	0xf3,0xc3


.section	.pdata
.p2align	2
.rva	.LSEH_begin_x25519_fe51_mul
.rva	.LSEH_end_x25519_fe51_mul
.rva	.LSEH_info_x25519_fe51_mul

.rva	.LSEH_begin_x25519_fe51_sqr
.rva	.LSEH_end_x25519_fe51_sqr
.rva	.LSEH_info_x25519_fe51_sqr

.rva	.LSEH_begin_x25519_fe51_mul121666
.rva	.LSEH_end_x25519_fe51_mul121666
.rva	.LSEH_info_x25519_fe51_mul121666
.section	.xdata
.p2align	3
.LSEH_info_x25519_fe51_mul:
.byte	9,0,0,0
.rva	full_handler
.rva	.Lfe51_mul_body,.Lfe51_mul_epilogue
.long	88,0
.LSEH_info_x25519_fe51_sqr:
.byte	9,0,0,0
.rva	full_handler
.rva	.Lfe51_sqr_body,.Lfe51_sqr_epilogue
.long	88,0
.LSEH_info_x25519_fe51_mul121666:
.byte	9,0,0,0
.rva	full_handler
.rva	.Lfe51_mul121666_body,.Lfe51_mul121666_epilogue
.long	88,0
