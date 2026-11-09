.text	
.globl	ossl_vaes_vpclmulqdq_capable
.def	ossl_vaes_vpclmulqdq_capable;	.scl 2;	.type 32;	.endef
ossl_vaes_vpclmulqdq_capable:
	xorl	%eax,%eax
	.byte	0xf3,0xc3


.globl	ossl_aes_gcm_init_avx512
.globl	ossl_aes_gcm_setiv_avx512
.globl	ossl_aes_gcm_update_aad_avx512
.globl	ossl_aes_gcm_encrypt_avx512
.globl	ossl_aes_gcm_decrypt_avx512
.globl	ossl_aes_gcm_finalize_avx512
.globl	ossl_gcm_gmult_avx512

.def	ossl_aes_gcm_init_avx512;	.scl 2;	.type 32;	.endef
ossl_aes_gcm_init_avx512:
ossl_aes_gcm_setiv_avx512:
ossl_aes_gcm_update_aad_avx512:
ossl_aes_gcm_encrypt_avx512:
ossl_aes_gcm_decrypt_avx512:
ossl_aes_gcm_finalize_avx512:
ossl_gcm_gmult_avx512:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

