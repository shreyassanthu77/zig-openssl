.text	



.globl	aesni_multi_cbc_encrypt
.def	aesni_multi_cbc_encrypt;	.scl 2;	.type 32;	.endef
.p2align	5
aesni_multi_cbc_encrypt:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_aesni_multi_cbc_encrypt:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	movq	%rsp,%rax

	pushq	%rbx

	pushq	%rbp

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	leaq	-168(%rsp),%rsp
	movaps	%xmm6,(%rsp)
	movaps	%xmm7,16(%rsp)
	movaps	%xmm8,32(%rsp)
	movaps	%xmm9,48(%rsp)
	movaps	%xmm10,64(%rsp)
	movaps	%xmm11,80(%rsp)
	movaps	%xmm12,96(%rsp)
	movaps	%xmm13,-104(%rax)
	movaps	%xmm14,-88(%rax)
	movaps	%xmm15,-72(%rax)






	subq	$48,%rsp
	andq	$-64,%rsp
	movq	%rax,16(%rsp)


.Lenc4x_body:
	movdqu	(%rsi),%xmm12
	leaq	120(%rsi),%rsi
	leaq	80(%rdi),%rdi

.Lenc4x_loop_grande:
	movl	%edx,24(%rsp)
	xorl	%edx,%edx

	movl	-64(%rdi),%ecx
	movq	-80(%rdi),%r8
	cmpl	%edx,%ecx
	movq	-72(%rdi),%r12
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	-56(%rdi),%xmm2
	movl	%ecx,32(%rsp)
	cmovleq	%rsp,%r8

	movl	-24(%rdi),%ecx
	movq	-40(%rdi),%r9
	cmpl	%edx,%ecx
	movq	-32(%rdi),%r13
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	-16(%rdi),%xmm3
	movl	%ecx,36(%rsp)
	cmovleq	%rsp,%r9

	movl	16(%rdi),%ecx
	movq	0(%rdi),%r10
	cmpl	%edx,%ecx
	movq	8(%rdi),%r14
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	24(%rdi),%xmm4
	movl	%ecx,40(%rsp)
	cmovleq	%rsp,%r10

	movl	56(%rdi),%ecx
	movq	40(%rdi),%r11
	cmpl	%edx,%ecx
	movq	48(%rdi),%r15
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	64(%rdi),%xmm5
	movl	%ecx,44(%rsp)
	cmovleq	%rsp,%r11
	testl	%edx,%edx
	jz	.Lenc4x_done

	movups	16-120(%rsi),%xmm1
	pxor	%xmm12,%xmm2
	movups	32-120(%rsi),%xmm0
	pxor	%xmm12,%xmm3
	movl	240-120(%rsi),%eax
	pxor	%xmm12,%xmm4
	movdqu	(%r8),%xmm6
	pxor	%xmm12,%xmm5
	movdqu	(%r9),%xmm7
	pxor	%xmm6,%xmm2
	movdqu	(%r10),%xmm8
	pxor	%xmm7,%xmm3
	movdqu	(%r11),%xmm9
	pxor	%xmm8,%xmm4
	pxor	%xmm9,%xmm5
	movdqa	32(%rsp),%xmm10
	xorq	%rbx,%rbx
	jmp	.Loop_enc4x

.p2align	5
.Loop_enc4x:
	addq	$16,%rbx
	leaq	16(%rsp),%rbp
	movl	$1,%ecx
	subq	%rbx,%rbp

.byte	102,15,56,220,209
	prefetcht0	31(%r8,%rbx,1)
	prefetcht0	31(%r9,%rbx,1)
.byte	102,15,56,220,217
	prefetcht0	31(%r10,%rbx,1)
	prefetcht0	31(%r10,%rbx,1)
.byte	102,15,56,220,225
.byte	102,15,56,220,233
	movups	48-120(%rsi),%xmm1
	cmpl	32(%rsp),%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
	cmovgeq	%rbp,%r8
	cmovgq	%rbp,%r12
.byte	102,15,56,220,232
	movups	-56(%rsi),%xmm0
	cmpl	36(%rsp),%ecx
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
	cmovgeq	%rbp,%r9
	cmovgq	%rbp,%r13
.byte	102,15,56,220,233
	movups	-40(%rsi),%xmm1
	cmpl	40(%rsp),%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
	cmovgeq	%rbp,%r10
	cmovgq	%rbp,%r14
.byte	102,15,56,220,232
	movups	-24(%rsi),%xmm0
	cmpl	44(%rsp),%ecx
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
	cmovgeq	%rbp,%r11
	cmovgq	%rbp,%r15
.byte	102,15,56,220,233
	movups	-8(%rsi),%xmm1
	movdqa	%xmm10,%xmm11
.byte	102,15,56,220,208
	prefetcht0	15(%r12,%rbx,1)
	prefetcht0	15(%r13,%rbx,1)
.byte	102,15,56,220,216
	prefetcht0	15(%r14,%rbx,1)
	prefetcht0	15(%r15,%rbx,1)
.byte	102,15,56,220,224
.byte	102,15,56,220,232
	movups	128-120(%rsi),%xmm0
	pxor	%xmm12,%xmm12

.byte	102,15,56,220,209
	pcmpgtd	%xmm12,%xmm11
	movdqu	-120(%rsi),%xmm12
.byte	102,15,56,220,217
	paddd	%xmm11,%xmm10
	movdqa	%xmm10,32(%rsp)
.byte	102,15,56,220,225
.byte	102,15,56,220,233
	movups	144-120(%rsi),%xmm1

	cmpl	$11,%eax

.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
.byte	102,15,56,220,232
	movups	160-120(%rsi),%xmm0

	jb	.Lenc4x_tail

.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
	movups	176-120(%rsi),%xmm1

.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
.byte	102,15,56,220,232
	movups	192-120(%rsi),%xmm0

	je	.Lenc4x_tail

.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
	movups	208-120(%rsi),%xmm1

.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
.byte	102,15,56,220,232
	movups	224-120(%rsi),%xmm0
	jmp	.Lenc4x_tail

.p2align	5
.Lenc4x_tail:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
	movdqu	(%r8,%rbx,1),%xmm6
	movdqu	16-120(%rsi),%xmm1

.byte	102,15,56,221,208
	movdqu	(%r9,%rbx,1),%xmm7
	pxor	%xmm12,%xmm6
.byte	102,15,56,221,216
	movdqu	(%r10,%rbx,1),%xmm8
	pxor	%xmm12,%xmm7
.byte	102,15,56,221,224
	movdqu	(%r11,%rbx,1),%xmm9
	pxor	%xmm12,%xmm8
.byte	102,15,56,221,232
	movdqu	32-120(%rsi),%xmm0
	pxor	%xmm12,%xmm9

	movups	%xmm2,-16(%r12,%rbx,1)
	pxor	%xmm6,%xmm2
	movups	%xmm3,-16(%r13,%rbx,1)
	pxor	%xmm7,%xmm3
	movups	%xmm4,-16(%r14,%rbx,1)
	pxor	%xmm8,%xmm4
	movups	%xmm5,-16(%r15,%rbx,1)
	pxor	%xmm9,%xmm5

	decl	%edx
	jnz	.Loop_enc4x

	movq	16(%rsp),%rax

	movl	24(%rsp),%edx











	leaq	160(%rdi),%rdi
	decl	%edx
	jnz	.Lenc4x_loop_grande

.Lenc4x_done:
	movaps	-216(%rax),%xmm6
	movaps	-200(%rax),%xmm7
	movaps	-184(%rax),%xmm8
	movaps	-168(%rax),%xmm9
	movaps	-152(%rax),%xmm10
	movaps	-136(%rax),%xmm11
	movaps	-120(%rax),%xmm12



	movq	-48(%rax),%r15

	movq	-40(%rax),%r14

	movq	-32(%rax),%r13

	movq	-24(%rax),%r12

	movq	-16(%rax),%rbp

	movq	-8(%rax),%rbx

	leaq	(%rax),%rsp

.Lenc4x_epilogue:
	movq	8(%rsp),%rdi
	movq	16(%rsp),%rsi
	.byte	0xf3,0xc3

.LSEH_end_aesni_multi_cbc_encrypt:

.globl	aesni_multi_cbc_decrypt
.def	aesni_multi_cbc_decrypt;	.scl 2;	.type 32;	.endef
.p2align	5
aesni_multi_cbc_decrypt:
	movq	%rdi,8(%rsp)
	movq	%rsi,16(%rsp)
	movq	%rsp,%rax
.LSEH_begin_aesni_multi_cbc_decrypt:
	movq	%rcx,%rdi
	movq	%rdx,%rsi
	movq	%r8,%rdx


	movq	%rsp,%rax

	pushq	%rbx

	pushq	%rbp

	pushq	%r12

	pushq	%r13

	pushq	%r14

	pushq	%r15

	leaq	-168(%rsp),%rsp
	movaps	%xmm6,(%rsp)
	movaps	%xmm7,16(%rsp)
	movaps	%xmm8,32(%rsp)
	movaps	%xmm9,48(%rsp)
	movaps	%xmm10,64(%rsp)
	movaps	%xmm11,80(%rsp)
	movaps	%xmm12,96(%rsp)
	movaps	%xmm13,-104(%rax)
	movaps	%xmm14,-88(%rax)
	movaps	%xmm15,-72(%rax)






	subq	$48,%rsp
	andq	$-64,%rsp
	movq	%rax,16(%rsp)


.Ldec4x_body:
	movdqu	(%rsi),%xmm12
	leaq	120(%rsi),%rsi
	leaq	80(%rdi),%rdi

.Ldec4x_loop_grande:
	movl	%edx,24(%rsp)
	xorl	%edx,%edx

	movl	-64(%rdi),%ecx
	movq	-80(%rdi),%r8
	cmpl	%edx,%ecx
	movq	-72(%rdi),%r12
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	-56(%rdi),%xmm6
	movl	%ecx,32(%rsp)
	cmovleq	%rsp,%r8

	movl	-24(%rdi),%ecx
	movq	-40(%rdi),%r9
	cmpl	%edx,%ecx
	movq	-32(%rdi),%r13
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	-16(%rdi),%xmm7
	movl	%ecx,36(%rsp)
	cmovleq	%rsp,%r9

	movl	16(%rdi),%ecx
	movq	0(%rdi),%r10
	cmpl	%edx,%ecx
	movq	8(%rdi),%r14
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	24(%rdi),%xmm8
	movl	%ecx,40(%rsp)
	cmovleq	%rsp,%r10

	movl	56(%rdi),%ecx
	movq	40(%rdi),%r11
	cmpl	%edx,%ecx
	movq	48(%rdi),%r15
	cmovgl	%ecx,%edx
	testl	%ecx,%ecx

	movdqu	64(%rdi),%xmm9
	movl	%ecx,44(%rsp)
	cmovleq	%rsp,%r11
	testl	%edx,%edx
	jz	.Ldec4x_done

	movups	16-120(%rsi),%xmm1
	movups	32-120(%rsi),%xmm0
	movl	240-120(%rsi),%eax
	movdqu	(%r8),%xmm2
	movdqu	(%r9),%xmm3
	pxor	%xmm12,%xmm2
	movdqu	(%r10),%xmm4
	pxor	%xmm12,%xmm3
	movdqu	(%r11),%xmm5
	pxor	%xmm12,%xmm4
	pxor	%xmm12,%xmm5
	movdqa	32(%rsp),%xmm10
	xorq	%rbx,%rbx
	jmp	.Loop_dec4x

.p2align	5
.Loop_dec4x:
	addq	$16,%rbx
	leaq	16(%rsp),%rbp
	movl	$1,%ecx
	subq	%rbx,%rbp

.byte	102,15,56,222,209
	prefetcht0	31(%r8,%rbx,1)
	prefetcht0	31(%r9,%rbx,1)
.byte	102,15,56,222,217
	prefetcht0	31(%r10,%rbx,1)
	prefetcht0	31(%r11,%rbx,1)
.byte	102,15,56,222,225
.byte	102,15,56,222,233
	movups	48-120(%rsi),%xmm1
	cmpl	32(%rsp),%ecx
.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
	cmovgeq	%rbp,%r8
	cmovgq	%rbp,%r12
.byte	102,15,56,222,232
	movups	-56(%rsi),%xmm0
	cmpl	36(%rsp),%ecx
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
	cmovgeq	%rbp,%r9
	cmovgq	%rbp,%r13
.byte	102,15,56,222,233
	movups	-40(%rsi),%xmm1
	cmpl	40(%rsp),%ecx
.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
	cmovgeq	%rbp,%r10
	cmovgq	%rbp,%r14
.byte	102,15,56,222,232
	movups	-24(%rsi),%xmm0
	cmpl	44(%rsp),%ecx
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
	cmovgeq	%rbp,%r11
	cmovgq	%rbp,%r15
.byte	102,15,56,222,233
	movups	-8(%rsi),%xmm1
	movdqa	%xmm10,%xmm11
.byte	102,15,56,222,208
	prefetcht0	15(%r12,%rbx,1)
	prefetcht0	15(%r13,%rbx,1)
.byte	102,15,56,222,216
	prefetcht0	15(%r14,%rbx,1)
	prefetcht0	15(%r15,%rbx,1)
.byte	102,15,56,222,224
.byte	102,15,56,222,232
	movups	128-120(%rsi),%xmm0
	pxor	%xmm12,%xmm12

.byte	102,15,56,222,209
	pcmpgtd	%xmm12,%xmm11
	movdqu	-120(%rsi),%xmm12
.byte	102,15,56,222,217
	paddd	%xmm11,%xmm10
	movdqa	%xmm10,32(%rsp)
.byte	102,15,56,222,225
.byte	102,15,56,222,233
	movups	144-120(%rsi),%xmm1

	cmpl	$11,%eax

.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
.byte	102,15,56,222,232
	movups	160-120(%rsi),%xmm0

	jb	.Ldec4x_tail

.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,222,233
	movups	176-120(%rsi),%xmm1

.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
.byte	102,15,56,222,232
	movups	192-120(%rsi),%xmm0

	je	.Ldec4x_tail

.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,222,233
	movups	208-120(%rsi),%xmm1

.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
.byte	102,15,56,222,232
	movups	224-120(%rsi),%xmm0
	jmp	.Ldec4x_tail

.p2align	5
.Ldec4x_tail:
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
	pxor	%xmm0,%xmm6
	pxor	%xmm0,%xmm7
.byte	102,15,56,222,233
	movdqu	16-120(%rsi),%xmm1
	pxor	%xmm0,%xmm8
	pxor	%xmm0,%xmm9
	movdqu	32-120(%rsi),%xmm0

.byte	102,15,56,223,214
.byte	102,15,56,223,223
	movdqu	-16(%r8,%rbx,1),%xmm6
	movdqu	-16(%r9,%rbx,1),%xmm7
.byte	102,65,15,56,223,224
.byte	102,65,15,56,223,233
	movdqu	-16(%r10,%rbx,1),%xmm8
	movdqu	-16(%r11,%rbx,1),%xmm9

	movups	%xmm2,-16(%r12,%rbx,1)
	movdqu	(%r8,%rbx,1),%xmm2
	movups	%xmm3,-16(%r13,%rbx,1)
	movdqu	(%r9,%rbx,1),%xmm3
	pxor	%xmm12,%xmm2
	movups	%xmm4,-16(%r14,%rbx,1)
	movdqu	(%r10,%rbx,1),%xmm4
	pxor	%xmm12,%xmm3
	movups	%xmm5,-16(%r15,%rbx,1)
	movdqu	(%r11,%rbx,1),%xmm5
	pxor	%xmm12,%xmm4
	pxor	%xmm12,%xmm5

	decl	%edx
	jnz	.Loop_dec4x

	movq	16(%rsp),%rax

	movl	24(%rsp),%edx

	leaq	160(%rdi),%rdi
	decl	%edx
	jnz	.Ldec4x_loop_grande

.Ldec4x_done:
	movaps	-216(%rax),%xmm6
	movaps	-200(%rax),%xmm7
	movaps	-184(%rax),%xmm8
	movaps	-168(%rax),%xmm9
	movaps	-152(%rax),%xmm10
	movaps	-136(%rax),%xmm11
	movaps	-120(%rax),%xmm12



	movq	-48(%rax),%r15

	movq	-40(%rax),%r14

	movq	-32(%rax),%r13

	movq	-24(%rax),%r12

	movq	-16(%rax),%rbp

	movq	-8(%rax),%rbx

	leaq	(%rax),%rsp

.Ldec4x_epilogue:
	movq	8(%rsp),%rdi
	movq	16(%rsp),%rsi
	.byte	0xf3,0xc3

.LSEH_end_aesni_multi_cbc_decrypt:

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
	jb	.Lin_prologue

	movq	152(%r8),%rax

	movl	4(%r11),%r10d
	leaq	(%rsi,%r10,1),%r10
	cmpq	%r10,%rbx
	jae	.Lin_prologue

	movq	16(%rax),%rax

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

	leaq	-56-160(%rax),%rsi
	leaq	512(%r8),%rdi
	movl	$20,%ecx
.long	0xa548f3fc

.Lin_prologue:
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
.rva	.LSEH_begin_aesni_multi_cbc_encrypt
.rva	.LSEH_end_aesni_multi_cbc_encrypt
.rva	.LSEH_info_aesni_multi_cbc_encrypt
.rva	.LSEH_begin_aesni_multi_cbc_decrypt
.rva	.LSEH_end_aesni_multi_cbc_decrypt
.rva	.LSEH_info_aesni_multi_cbc_decrypt
.section	.xdata
.p2align	3
.LSEH_info_aesni_multi_cbc_encrypt:
.byte	9,0,0,0
.rva	se_handler
.rva	.Lenc4x_body,.Lenc4x_epilogue
.LSEH_info_aesni_multi_cbc_decrypt:
.byte	9,0,0,0
.rva	se_handler
.rva	.Ldec4x_body,.Ldec4x_epilogue
