; ModuleID = 'cpp Codes/3.cpp'
source_filename = "cpp Codes/3.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"%d %d\0A\00", align 1

; Function Attrs: mustprogress noinline nounwind uwtable
define dso_local noundef i32 @_Z12collatzStepsi(i32 noundef %n) #0 {
entry:
  %n.addr = alloca i32, align 4
  %steps = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  store i32 0, ptr %steps, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32, ptr %n.addr, align 4
  %cmp = icmp ne i32 %0, 1
  br i1 %cmp, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %1 = load i32, ptr %steps, align 4
  %cmp1 = icmp slt i32 %1, 1000
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %2 = phi i1 [ false, %while.cond ], [ %cmp1, %land.rhs ]
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %3 = load i32, ptr %n.addr, align 4
  %rem = srem i32 %3, 2
  %cmp2 = icmp eq i32 %rem, 0
  br i1 %cmp2, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %4 = load i32, ptr %n.addr, align 4
  %div = sdiv i32 %4, 2
  store i32 %div, ptr %n.addr, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %5 = load i32, ptr %n.addr, align 4
  %mul = mul nsw i32 3, %5
  %add = add nsw i32 %mul, 1
  store i32 %add, ptr %n.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %6 = load i32, ptr %steps, align 4
  %inc = add nsw i32 %6, 1
  store i32 %inc, ptr %steps, align 4
  br label %while.cond, !llvm.loop !6

while.end:                                        ; preds = %land.end
  %7 = load i32, ptr %steps, align 4
  ret i32 %7
}

; Function Attrs: mustprogress noinline norecurse uwtable
define dso_local noundef i32 @main() #1 {
entry:
  %retval = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  %call = call noundef i32 @_Z12collatzStepsi(i32 noundef 6)
  %call1 = call noundef i32 @_Z12collatzStepsi(i32 noundef 27)
  %call2 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %call, i32 noundef %call1)
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #2

attributes #0 = { mustprogress noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
