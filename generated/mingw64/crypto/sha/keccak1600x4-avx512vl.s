.text	

.globl	SHA3_avx512vl_capable
.def	SHA3_avx512vl_capable;	.scl 2;	.type 32;	.endef
SHA3_avx512vl_capable:
	xorl	%eax,%eax
	.byte	0xf3,0xc3


.globl	SHA3_shake128_x4_inc_absorb_avx512vl
.globl	SHA3_shake256_x4_inc_absorb_avx512vl
.globl	SHA3_shake128_x4_inc_finalize_avx512vl
.globl	SHA3_shake256_x4_inc_finalize_avx512vl
.globl	SHA3_shake128_x4_inc_squeeze_avx512vl
.globl	SHA3_shake256_x4_inc_squeeze_avx512vl
.globl	SHA3_shake128_x4_avx512vl
.globl	SHA3_shake256_x4_avx512vl
.def	SHA3_shake128_x4_inc_absorb_avx512vl;	.scl 2;	.type 32;	.endef
SHA3_shake128_x4_inc_absorb_avx512vl:
SHA3_shake256_x4_inc_absorb_avx512vl:
SHA3_shake128_x4_inc_finalize_avx512vl:
SHA3_shake256_x4_inc_finalize_avx512vl:
SHA3_shake128_x4_inc_squeeze_avx512vl:
SHA3_shake256_x4_inc_squeeze_avx512vl:
SHA3_shake128_x4_avx512vl:
SHA3_shake256_x4_avx512vl:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

