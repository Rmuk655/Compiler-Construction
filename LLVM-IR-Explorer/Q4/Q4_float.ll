; ModuleID = 'Q4/Q4_float.c'
source_filename = "Q4/Q4_float.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca float, align 4
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  store i32 0, ptr %1, align 4
  store float 1.500000e+00, ptr %2, align 4
  store double 2.500000e+00, ptr %3, align 8
  %6 = load double, ptr %3, align 8
  %7 = load float, ptr %2, align 4
  %8 = fpext float %7 to double
  %9 = fadd double %6, %8
  store double %9, ptr %3, align 8
  %10 = load double, ptr %3, align 8
  %11 = fptrunc double %10 to float
  %12 = load float, ptr %2, align 4
  %13 = fmul float %11, %12
  store float %13, ptr %2, align 4
  %14 = load double, ptr %3, align 8
  %15 = fptosi double %14 to i32
  store i32 %15, ptr %4, align 4
  %16 = load i32, ptr %4, align 4
  %17 = sitofp i32 %16 to double
  store double %17, ptr %5, align 8
  %18 = load float, ptr %2, align 4
  %19 = fpext float %18 to double
  %20 = load double, ptr %3, align 8
  %21 = fcmp olt double %19, %20
  br i1 %21, label %22, label %25

22:                                               ; preds = %0
  %23 = load double, ptr %5, align 8
  %24 = fdiv double %23, 2.000000e+00
  store double %24, ptr %5, align 8
  br label %25

25:                                               ; preds = %22, %0
  %26 = load double, ptr %5, align 8
  %27 = fneg double %26
  store double %27, ptr %5, align 8
  %28 = load double, ptr %5, align 8
  %29 = fptosi double %28 to i32
  ret i32 %29
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 17.0.6 (https://github.com/llvm/llvm-project.git 6009708b4367171ccdbf4b5905cb6a803753fe18)"}
