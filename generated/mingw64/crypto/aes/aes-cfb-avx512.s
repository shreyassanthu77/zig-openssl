.text	
.globl	ossl_aes_cfb128_vaes_enc
.globl	ossl_aes_cfb128_vaes_dec




ossl_aes_cfb128_vaes_enc:
ossl_aes_cfb128_vaes_dec:
.byte	0x0f,0x0b

	.byte	0xf3,0xc3











.globl	ossl_aes_cfb128_vaes_eligible
.def	ossl_aes_cfb128_vaes_eligible;	.scl 2;	.type 32;	.endef
ossl_aes_cfb128_vaes_eligible:
	xorl	%eax,%eax
	.byte	0xf3,0xc3

