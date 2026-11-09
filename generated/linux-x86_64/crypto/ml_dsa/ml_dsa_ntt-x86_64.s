.text	

.globl	ml_dsa_ntt_avx2_capable
.type	ml_dsa_ntt_avx2_capable,@function
ml_dsa_ntt_avx2_capable:
	xorl	%eax,%eax
	.byte	0xf3,0xc3
.size	ml_dsa_ntt_avx2_capable, .-ml_dsa_ntt_avx2_capable

.globl	ml_dsa_poly_ntt_mult_avx2
.globl	ml_dsa_poly_ntt_avx2
.globl	ml_dsa_poly_ntt_inverse_avx2
.type	ml_dsa_poly_ntt_mult_avx2,@function
ml_dsa_poly_ntt_mult_avx2:
ml_dsa_poly_ntt_avx2:
ml_dsa_poly_ntt_inverse_avx2:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3
.size	ml_dsa_poly_ntt_mult_avx2, .-ml_dsa_poly_ntt_mult_avx2
	.section ".note.gnu.property", "a"
	.p2align 3
	.long 1f - 0f
	.long 4f - 1f
	.long 5
0:
	# "GNU" encoded with .byte, since .asciz isn't supported
	# on Solaris.
	.byte 0x47
	.byte 0x4e
	.byte 0x55
	.byte 0
1:
	.p2align 3
	.long 0xc0000002
	.long 3f - 2f
2:
	.long 3
3:
	.p2align 3
4:
