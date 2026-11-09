.text	

.globl	_ml_dsa_ntt_avx2_capable

_ml_dsa_ntt_avx2_capable:
	xorl	%eax,%eax
	.byte	0xf3,0xc3


.globl	_ml_dsa_poly_ntt_mult_avx2
.globl	_ml_dsa_poly_ntt_avx2
.globl	_ml_dsa_poly_ntt_inverse_avx2

_ml_dsa_poly_ntt_mult_avx2:
_ml_dsa_poly_ntt_avx2:
_ml_dsa_poly_ntt_inverse_avx2:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

