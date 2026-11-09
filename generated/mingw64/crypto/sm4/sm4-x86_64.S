.text	

.globl	hw_x86_64_sm4_set_key
.def	hw_x86_64_sm4_set_key;	.scl 2;	.type 32;	.endef
hw_x86_64_sm4_set_key:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3


.globl	hw_x86_64_sm4_encrypt
.def	hw_x86_64_sm4_encrypt;	.scl 2;	.type 32;	.endef
hw_x86_64_sm4_encrypt:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3


.globl	hw_x86_64_sm4_decrypt
.def	hw_x86_64_sm4_decrypt;	.scl 2;	.type 32;	.endef
hw_x86_64_sm4_decrypt:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

