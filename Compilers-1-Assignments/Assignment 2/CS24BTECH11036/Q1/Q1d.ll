; ModuleID = 'Q1d.c'
source_filename = "Q1d.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 1, ptr %2, align 4
  store double 2.000000e+00, ptr %3, align 8
  %8 = load double, ptr %3, align 8
  %9 = fptosi double %8 to i32
  store i32 %9, ptr %2, align 4
  store i32 3, ptr %4, align 4
  store i64 4, ptr %5, align 8
  %10 = load i32, ptr %4, align 4
  %11 = sext i32 %10 to i64
  store i64 %11, ptr %5, align 8
  store i64 20, ptr %6, align 8
  store i32 10, ptr %7, align 4
  %12 = load i32, ptr %7, align 4
  %13 = sext i32 %12 to i64
  store i64 %13, ptr %6, align 8
  %14 = load i64, ptr %5, align 8
  %15 = trunc i64 %14 to i32
  store i32 %15, ptr %4, align 4
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
