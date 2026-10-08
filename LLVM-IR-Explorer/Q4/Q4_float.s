	.text
	.file	"Q4_float.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function main
.LCPI0_0:
	.quad	0x4004000000000000              # double 2.5
.LCPI0_2:
	.quad	0x4000000000000000              # double 2
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI0_1:
	.long	0x3fc00000                      # float 1.5
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
	cvttsd2si	-16(%rbp), %eax
	movl	%eax, -20(%rbp)
	cvtsi2sdl	-20(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	movss	-8(%rbp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0                # xmm0 = mem[0],zero
	ucomisd	%xmm1, %xmm0
	jbe	.LBB0_2
# %bb.1:
	movsd	-32(%rbp), %xmm0                # xmm0 = mem[0],zero
	movsd	.LCPI0_2(%rip), %xmm1           # xmm1 = mem[0],zero
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
.LBB0_2:
	movsd	-32(%rbp), %xmm0                # xmm0 = mem[0],zero
	movq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rcx     # imm = 0x8000000000000000
	xorq	%rcx, %rax
	movq	%rax, %xmm0
	movsd	%xmm0, -32(%rbp)
	cvttsd2si	-32(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 17.0.6 (https://github.com/llvm/llvm-project.git 6009708b4367171ccdbf4b5905cb6a803753fe18)"
	.section	".note.GNU-stack","",@progbits
