.text	

.globl	ossl_rsaz_avx512ifma_eligible
.def	ossl_rsaz_avx512ifma_eligible;	.scl 2;	.type 32;	.endef
ossl_rsaz_avx512ifma_eligible:
	xorl	%eax,%eax
	.byte	0xf3,0xc3


.globl	ossl_rsaz_amm52x20_x1_ifma256
.globl	ossl_rsaz_amm52x20_x2_ifma256
.globl	ossl_extract_multiplier_2x20_win5
.def	ossl_rsaz_amm52x20_x1_ifma256;	.scl 2;	.type 32;	.endef
ossl_rsaz_amm52x20_x1_ifma256:
ossl_rsaz_amm52x20_x2_ifma256:
ossl_extract_multiplier_2x20_win5:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

