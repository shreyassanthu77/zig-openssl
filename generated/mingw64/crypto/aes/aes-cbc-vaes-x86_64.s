.text	

.globl	ossl_aes_cbc_vaes_cleanup_eligible

.def	ossl_aes_cbc_vaes_cleanup_eligible;	.scl 2;	.type 32;	.endef
.p2align	4
ossl_aes_cbc_vaes_cleanup_eligible:

.byte	243,15,30,250
	xorl	%eax,%eax
	.byte	0xf3,0xc3



.globl	ossl_aes_cbc_vaes_cleanup

.def	ossl_aes_cbc_vaes_cleanup;	.scl 2;	.type 32;	.endef
ossl_aes_cbc_vaes_cleanup:

.byte	243,15,30,250
.byte	0x0f,0x0b
	.byte	0xf3,0xc3


