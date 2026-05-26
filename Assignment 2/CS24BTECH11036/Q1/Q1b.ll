; ModuleID = 'Q1b.c'
source_filename = "Q1b.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 2, ptr %2, align 4
  store i32 3, ptr %3, align 4
  %5 = load i32, ptr %2, align 4
  %6 = icmp eq i32 %5, 2
  br i1 %6, label %7, label %8

7:                                                ; preds = %0
  store i32 2, ptr %2, align 4
  br label %9

8:                                                ; preds = %0
  store i32 2, ptr %2, align 4
  br label %9

9:                                                ; preds = %8, %7
  %10 = load i32, ptr %2, align 4
  switch i32 %10, label %13 [
    i32 1, label %11
    i32 2, label %12
  ]

11:                                               ; preds = %9
  store i32 2, ptr %2, align 4
  br label %14

12:                                               ; preds = %9
  store i32 2, ptr %2, align 4
  br label %14

13:                                               ; preds = %9
  store i32 2, ptr %2, align 4
  br label %14

14:                                               ; preds = %13, %12, %11
  %15 = load i32, ptr %2, align 4
  store i32 %15, ptr %4, align 4
  br label %16

16:                                               ; preds = %22, %14
  %17 = load i32, ptr %4, align 4
  %18 = icmp slt i32 %17, 5
  br i1 %18, label %19, label %25

19:                                               ; preds = %16
  %20 = load i32, ptr %2, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %2, align 4
  br label %22

22:                                               ; preds = %19
  %23 = load i32, ptr %4, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, ptr %4, align 4
  br label %16, !llvm.loop !6

25:                                               ; preds = %16
  br label %26

26:                                               ; preds = %29, %25
  %27 = load i32, ptr %2, align 4
  %28 = icmp slt i32 %27, 5
  br i1 %28, label %29, label %32

29:                                               ; preds = %26
  %30 = load i32, ptr %2, align 4
  %31 = add nsw i32 %30, 1
  store i32 %31, ptr %2, align 4
  br label %26, !llvm.loop !8

32:                                               ; preds = %26
  br label %33

33:                                               ; preds = %36, %32
  %34 = load i32, ptr %2, align 4
  %35 = add nsw i32 %34, 1
  store i32 %35, ptr %2, align 4
  br label %36

36:                                               ; preds = %33
  %37 = load i32, ptr %2, align 4
  %38 = icmp slt i32 %37, 5
  br i1 %38, label %33, label %39, !llvm.loop !9

39:                                               ; preds = %36
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
!5 = !{!"Ubuntu clang version 17.0.6 (9ubuntu1)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
