.text	

.globl	ossl_aes_cbc_vaes_cleanup_eligible

.def	ossl_aes_cbc_vaes_cleanup_eligible;	.scl 2;	.type 32;	.endef
.p2align	4
ossl_aes_cbc_vaes_cleanup_eligible:

.byte	243,15,30,250
	movl	$1,%eax
	.byte	0xf3,0xc3









.globl	ossl_aes_cbc_vaes_cleanup

.def	ossl_aes_cbc_vaes_cleanup;	.scl 2;	.type 32;	.endef
.p2align	5
ossl_aes_cbc_vaes_cleanup:

.byte	243,15,30,250
	vpxord	%zmm0,%zmm0,%zmm0
	testq	%rdx,%rdx
	jz	.Lvaes_cbc_clear_registers

.Lvaes_cbc_clear_keys:
	vmovdqu64	%zmm0,(%rcx)
	addq	$64,%rcx
	decq	%rdx
	jnz	.Lvaes_cbc_clear_keys

.Lvaes_cbc_clear_registers:


	vpxor	%xmm0,%xmm0,%xmm0
	vpxor	%xmm1,%xmm1,%xmm1
	vpxor	%xmm2,%xmm2,%xmm2
	vpxor	%xmm3,%xmm3,%xmm3
	vpxor	%xmm4,%xmm4,%xmm4
	vpxor	%xmm5,%xmm5,%xmm5
	vpxord	%zmm16,%zmm16,%zmm16
	vpxord	%zmm17,%zmm17,%zmm17
	vpxord	%zmm18,%zmm18,%zmm18
	vpxord	%zmm19,%zmm19,%zmm19
	vpxord	%zmm20,%zmm20,%zmm20
	vpxord	%zmm21,%zmm21,%zmm21
	vpxord	%zmm22,%zmm22,%zmm22
	vpxord	%zmm23,%zmm23,%zmm23
	vpxord	%zmm24,%zmm24,%zmm24
	vpxord	%zmm25,%zmm25,%zmm25
	vpxord	%zmm26,%zmm26,%zmm26
	vpxord	%zmm27,%zmm27,%zmm27
	vpxord	%zmm28,%zmm28,%zmm28
	vpxord	%zmm29,%zmm29,%zmm29
	vpxord	%zmm30,%zmm30,%zmm30
	vpxord	%zmm31,%zmm31,%zmm31

	vzeroupper


	xorl	%eax,%eax
	xorl	%ecx,%ecx
	xorl	%edx,%edx
	xorl	%r8d,%r8d
	xorl	%r9d,%r9d
	xorl	%r10d,%r10d
	xorl	%r11d,%r11d
	.byte	0xf3,0xc3


