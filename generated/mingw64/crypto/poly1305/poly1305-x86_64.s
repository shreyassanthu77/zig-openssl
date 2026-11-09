.text	



.globl	poly1305_init

.globl	poly1305_blocks

.globl	poly1305_emit


.def	poly1305_init;	.scl 2;	.type 32;	.endef
.p2align	5
poly1305_init:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_poly1305_init:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	xorq	%rax,%rax
	movq	%rax,0(%rdi)
	movq	%rax,8(%rdi)
	movq	%rax,16(%rdi)

	cmpq	$0,%rsi
	je	.Lno_key

	leaq	poly1305_blocks(%rip),%r10
	leaq	poly1305_emit(%rip),%r11
	movq	$0x0ffffffc0fffffff,%rax
	movq	$0x0ffffffc0ffffffc,%rcx
	andq	0(%rsi),%rax
	andq	8(%rsi),%rcx
	movq	%rax,24(%rdi)
	movq	%rcx,32(%rdi)
	movq	%r10,0(%rdx)
	movq	%r11,8(%rdx)
	movl	$1,%eax
.Lno_key:
	movq	8(%rsp),%rdi
	movq	16(%rsp),%rsi
	.byte	0xf3,0xc3

.LSEH_end_poly1305_init:

.def	poly1305_blocks;	.scl 2;	.type 32;	.endef
.p2align	5
poly1305_blocks:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_poly1305_blocks:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx
	movq	%r9,%rcx


.byte	243,15,30,250
.Lblocks:
	shrq	$4,%rdx
	jz	.Lno_data

	pushq	%rbx

	pushq	%rbp

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

.Lblocks_body:

	movq	%rdx,%r15

	movq	24(%rdi),%r11
	movq	32(%rdi),%r13

	movq	0(%rdi),%r14
	movq	8(%rdi),%rbx
	movq	16(%rdi),%rbp

	movq	%r13,%r12
	shrq	$2,%r13
	movq	%r12,%rax
	addq	%r12,%r13
	jmp	.Loop

.p2align	5
.Loop:
	addq	0(%rsi),%r14
	adcq	8(%rsi),%rbx
	leaq	16(%rsi),%rsi
	adcq	%rcx,%rbp
	mulq	%r14
	movq	%rax,%r9
	movq	%r11,%rax
	movq	%rdx,%r10

	mulq	%r14
	movq	%rax,%r14
	movq	%r11,%rax
	movq	%rdx,%r8

	mulq	%rbx
	addq	%rax,%r9
	movq	%r13,%rax
	adcq	%rdx,%r10

	mulq	%rbx
	movq	%rbp,%rbx
	addq	%rax,%r14
	adcq	%rdx,%r8

	imulq	%r13,%rbx
	addq	%rbx,%r9
	movq	%r8,%rbx
	adcq	$0,%r10

	imulq	%r11,%rbp
	addq	%r9,%rbx
	movq	$-4,%rax
	adcq	%rbp,%r10

	andq	%r10,%rax
	movq	%r10,%rbp
	shrq	$2,%r10
	andq	$3,%rbp
	addq	%r10,%rax
	addq	%rax,%r14
	adcq	$0,%rbx
	adcq	$0,%rbp
	movq	%r12,%rax
	decq	%r15
	jnz	.Loop

	movq	%r14,0(%rdi)
	movq	%rbx,8(%rdi)
	movq	%rbp,16(%rdi)

	movq	0(%rsp),%r15

	movq	8(%rsp),%r14

	movq	16(%rsp),%r13

	movq	24(%rsp),%r12

	movq	32(%rsp),%rbp

	movq	40(%rsp),%rbx

	leaq	48(%rsp),%rsp

.Lno_data:
.Lblocks_epilogue:
	movq	8(%rsp),%rdi
	movq	16(%rsp),%rsi
	.byte	0xf3,0xc3

.LSEH_end_poly1305_blocks:

.def	poly1305_emit;	.scl 2;	.type 32;	.endef
.p2align	5
poly1305_emit:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_poly1305_emit:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


.byte	243,15,30,250
.Lemit:
	movq	0(%rdi),%r8
	movq	8(%rdi),%r9
	movq	16(%rdi),%r10

	movq	%r8,%rax
	addq	$5,%r8
	movq	%r9,%rcx
	adcq	$0,%r9
	adcq	$0,%r10
	shrq	$2,%r10
	cmovnzq	%r8,%rax
	cmovnzq	%r9,%rcx

	addq	0(%rdx),%rax
	adcq	8(%rdx),%rcx
	movq	%rax,0(%rsi)
	movq	%rcx,8(%rsi)

	movq	8(%rsp),%rdi
	movq	16(%rsp),%rsi
	.byte	0xf3,0xc3

.LSEH_end_poly1305_emit:
.byte	80,111,108,121,49,51,48,53,32,102,111,114,32,120,56,54,95,54,52,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,104,116,116,112,115,58,47,47,103,105,116,104,117,98,46,99,111,109,47,100,111,116,45,97,115,109,62,0
.p2align	4
.globl	xor128_encrypt_n_pad
.def	xor128_encrypt_n_pad;	.scl 2;	.type 32;	.endef
.p2align	4
xor128_encrypt_n_pad:

	subq	%r8,%rdx
	subq	%r8,%rcx
	movq	%r9,%r10
	shrq	$4,%r9
	jz	.Ltail_enc
	nop
.Loop_enc_xmm:
	movdqu	(%rdx,%r8,1),%xmm0
	pxor	(%r8),%xmm0
	movdqu	%xmm0,(%rcx,%r8,1)
	movdqa	%xmm0,(%r8)
	leaq	16(%r8),%r8
	decq	%r9
	jnz	.Loop_enc_xmm

	andq	$15,%r10
	jz	.Ldone_enc

.Ltail_enc:
	movq	$16,%r9
	subq	%r10,%r9
	xorl	%eax,%eax
.Loop_enc_byte:
	movb	(%rdx,%r8,1),%al
	xorb	(%r8),%al
	movb	%al,(%rcx,%r8,1)
	movb	%al,(%r8)
	leaq	1(%r8),%r8
	decq	%r10
	jnz	.Loop_enc_byte

	xorl	%eax,%eax
.Loop_enc_pad:
	movb	%al,(%r8)
	leaq	1(%r8),%r8
	decq	%r9
	jnz	.Loop_enc_pad

.Ldone_enc:
	movq	%r8,%rax
	.byte	0xf3,0xc3



.globl	xor128_decrypt_n_pad
.def	xor128_decrypt_n_pad;	.scl 2;	.type 32;	.endef
.p2align	4
xor128_decrypt_n_pad:

	subq	%r8,%rdx
	subq	%r8,%rcx
	movq	%r9,%r10
	shrq	$4,%r9
	jz	.Ltail_dec
	nop
.Loop_dec_xmm:
	movdqu	(%rdx,%r8,1),%xmm0
	movdqa	(%r8),%xmm1
	pxor	%xmm0,%xmm1
	movdqu	%xmm1,(%rcx,%r8,1)
	movdqa	%xmm0,(%r8)
	leaq	16(%r8),%r8
	decq	%r9
	jnz	.Loop_dec_xmm

	pxor	%xmm1,%xmm1
	andq	$15,%r10
	jz	.Ldone_dec

.Ltail_dec:
	movq	$16,%r9
	subq	%r10,%r9
	xorl	%eax,%eax
	xorq	%r11,%r11
.Loop_dec_byte:
	movb	(%rdx,%r8,1),%r11b
	movb	(%r8),%al
	xorb	%r11b,%al
	movb	%al,(%rcx,%r8,1)
	movb	%r11b,(%r8)
	leaq	1(%r8),%r8
	decq	%r10
	jnz	.Loop_dec_byte

	xorl	%eax,%eax
.Loop_dec_pad:
	movb	%al,(%r8)
	leaq	1(%r8),%r8
	decq	%r9
	jnz	.Loop_dec_pad

.Ldone_dec:
	movq	%r8,%rax
	.byte	0xf3,0xc3



.def	se_handler;	.scl 3;	.type 32;	.endef
.p2align	4
se_handler:
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

	leaq	48(%rax),%rax

	movq	-8(%rax),%rbx
	movq	-16(%rax),%rbp
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

	jmp	.Lcommon_seh_tail


.def	avx_handler;	.scl 3;	.type 32;	.endef
.p2align	4
avx_handler:
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

	movq	208(%r8),%rax

	leaq	80(%rax),%rsi
	leaq	248(%rax),%rax
	leaq	512(%r8),%rdi
	movl	$20,%ecx
.long	0xa548f3fc

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
.rva	.LSEH_begin_poly1305_init
.rva	.LSEH_end_poly1305_init
.rva	.LSEH_info_poly1305_init

.rva	.LSEH_begin_poly1305_blocks
.rva	.LSEH_end_poly1305_blocks
.rva	.LSEH_info_poly1305_blocks

.rva	.LSEH_begin_poly1305_emit
.rva	.LSEH_end_poly1305_emit
.rva	.LSEH_info_poly1305_emit
.section	.xdata
.p2align	3
.LSEH_info_poly1305_init:
.byte	9,0,0,0
.rva	se_handler
.rva	.LSEH_begin_poly1305_init,.LSEH_begin_poly1305_init

.LSEH_info_poly1305_blocks:
.byte	9,0,0,0
.rva	se_handler
.rva	.Lblocks_body,.Lblocks_epilogue

.LSEH_info_poly1305_emit:
.byte	9,0,0,0
.rva	se_handler
.rva	.LSEH_begin_poly1305_emit,.LSEH_begin_poly1305_emit
