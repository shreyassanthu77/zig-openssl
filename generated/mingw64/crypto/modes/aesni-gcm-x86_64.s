.text	

.globl	aesni_gcm_encrypt
.def	aesni_gcm_encrypt;	.scl 2;	.type 32;	.endef
aesni_gcm_encrypt:

	xorl	%eax,%eax
	.byte	0xf3,0xc3



.globl	aesni_gcm_decrypt
.def	aesni_gcm_decrypt;	.scl 2;	.type 32;	.endef
aesni_gcm_decrypt:

	xorl	%eax,%eax
	.byte	0xf3,0xc3


