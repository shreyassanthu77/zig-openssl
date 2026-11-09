.text	

.globl	_hw_x86_64_sm4_set_key

_hw_x86_64_sm4_set_key:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3


.globl	_hw_x86_64_sm4_encrypt

_hw_x86_64_sm4_encrypt:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3


.globl	_hw_x86_64_sm4_decrypt

_hw_x86_64_sm4_decrypt:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3

