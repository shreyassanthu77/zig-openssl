.text	

.globl	ossl_rsaz_avxifma_eligible
.def	ossl_rsaz_avxifma_eligible;	.scl 2;	.type 32;	.endef
ossl_rsaz_avxifma_eligible:
	xorl	%eax,%eax
	.byte	0xf3,0xc3


.globl	ossl_rsaz_amm52x20_x1_avxifma256
.globl	ossl_rsaz_amm52x20_x2_avxifma256
.globl	ossl_extract_multiplier_2x20_win5_avx
.def	ossl_rsaz_amm52x20_x1_avxifma256;	.scl 2;	.type 32;	.endef
ossl_rsaz_amm52x20_x1_avxifma256:
ossl_rsaz_amm52x20_x2_avxifma256:
ossl_extract_multiplier_2x20_win5_avx:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

