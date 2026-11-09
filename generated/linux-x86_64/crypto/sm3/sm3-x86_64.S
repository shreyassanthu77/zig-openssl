.text	

.globl	ossl_hwsm3_block_data_order
.type	ossl_hwsm3_block_data_order,@function
ossl_hwsm3_block_data_order:
.byte	0x0f,0x0b
	.byte	0xf3,0xc3
.size	ossl_hwsm3_block_data_order, .-ossl_hwsm3_block_data_order
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
