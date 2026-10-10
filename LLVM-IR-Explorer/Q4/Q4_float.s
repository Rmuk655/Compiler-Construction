	.text
	.file	"Q4_float.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function main
.LCPI0_0:
	.quad	0x4016cccccccccccd              # double 5.7000000000000002
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI0_1:
	.long	0x40133333                      # float 2.29999995
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	$0, -4(%rbp)
	movss	.LCPI0_1(%rip), %xmm0           # xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -8(%rbp)
	movsd	.LCPI0_0(%rip), %xmm0           # xmm0 = mem[0],zero
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0                # xmm0 = mem[0],zero
	movss	-8(%rbp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	cvtss2sd	%xmm1, %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0                # xmm0 = mem[0],zero
	cvtsd2ss	%xmm0, %xmm0
	mulss	-8(%rbp), %xmm0
	movss	%xmm0, -8(%rbp)
	movsd	-16(%rbp), %xmm0                # xmm0 = mem[0],zero
	movss	-8(%rbp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	cvtss2sd	%xmm1, %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2si	%xmm0, %eax
	movl	%eax, -20(%rbp)
	movsd	-16(%rbp), %xmm1                # xmm1 = mem[0],zero
	movss	-8(%rbp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	ucomisd	%xmm1, %xmm0
	jbe	.LBB0_2
# %bb.1:
	cvtsi2ssl	-20(%rbp), %xmm0
	divss	-8(%rbp), %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	movss	-8(%rbp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	movd	%xmm0, %eax
	xorl	$2147483648, %eax               # imm = 0x80000000
	movd	%eax, %xmm0
	movss	%xmm0, -8(%rbp)
.LBB0_2:
	movl	-20(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 17.0.6 (https://github.com/llvm/llvm-project.git 6009708b4367171ccdbf4b5905cb6a803753fe18)"
	.section	".note.GNU-stack","",@progbits
