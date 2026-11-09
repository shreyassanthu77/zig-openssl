.text	

.globl	ml_dsa_ntt_avx2_capable
.def	ml_dsa_ntt_avx2_capable;	.scl 2;	.type 32;	.endef
ml_dsa_ntt_avx2_capable:
	xorl	%eax,%eax
	.byte	0xf3,0xc3


.globl	ml_dsa_poly_ntt_mult_avx2
.globl	ml_dsa_poly_ntt_avx2
.globl	ml_dsa_poly_ntt_inverse_avx2
.def	ml_dsa_poly_ntt_mult_avx2;	.scl 2;	.type 32;	.endef
ml_dsa_poly_ntt_mult_avx2:
ml_dsa_poly_ntt_avx2:
ml_dsa_poly_ntt_inverse_avx2:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

